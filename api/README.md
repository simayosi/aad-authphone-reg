# Server-side application for REST API endpoints

This server-side appliction is built
within a web application framework, [Sinatra](http://sinatrarb.com)
as a [Rack](https://github.com/rack/rack) application,
and bundled with required ruby gems using [Bundler](https://bundler.io).

## Getting Started

Install required ruby gems.
```sh
bundle install
```

Aquire a client credential from Azure Portal and set environment variables.
```sh
export MSGRAPH_TENANT=yourtenant.onmicrosoft.com    # tenant ID
export MSGRAPH_CLIENT_ID=client_ID      # assigned application (client) ID
export MSGRAPH_CLIENT_ASSERTION=JWT_assertion_string    # in certificate assertion case
export MSGRAPH_CLIENT_SECRET=client_secret  # in client secret case
```

Start the server-side application using `rackup`
with the above environment variables.
```sh
bundle exec rackup
```
The same command supports running as not only a standalone HTTP server but also CGI and FastCGI.
In the standalone case, the HTTP server listenes `localhost:9292` by default.


## Authentication & Authorization

You *MUST* configure user authentication *externally*,
because this application conducts no authentication.

By default, this application requires
for the UPN in every API call
to be identical to the `REMOTE_USER` environment variable.


## Configuration

Write `app_config.rb` file to configure this application.

### Example
```ruby
# Retrieve REMOTE_USER from HTTP headers for basic authentication
app.use Rack::Auth::Basic do true end
# Change UPN verification (local part comparison against REMOTE_USER)
app.verify_upn = ->(upn, env) { upn.split('@')[0] == env['REMOTE_USER'] }
# Enable logging feature of Sinatra
app.enable :logging
# Log Graph API calls to graph.log and rotate it weekly
app.graph_logger = Logger.new('graph.log', 'weekly')
# Normalize phone numbers (hyphen deletion)
app.normalize_number = ->(number) { number.delete('-') }
# Normalize UPN (domain completion)
app.normalize_upn = ->(upn) { upn.sub(/^([^@]*)$/, '\1@example.com') }
```


## Persistent Token Cache

By default, access tokens issued by Microsoft identity platform is
stored on memory and not shared among processes,
and so an access token is acquired and discarded for every access
when this application is executedd through CGI.

You can cache access tokens in PostrgreSQL or MySQL (MariaDB)
as the following.

1. Prepare your DB.
1. Install required ruby gems.
    ```sh
    # for PostgreSQL
    bundle config with pg
    # for MySQL
    bundle config with mysql2
    ```
1. Set `ACCESS_TOKEN_DB_URL` environment variable.
    ```sh
    # for PostgreSQL
    export ACCESS_TOKEN_DB_URL='postgres://dbuser:password@dbhost/dbname'
    # for MySQL
    export ACCESS_TOKEN_DB_URL='mysql2://dbuser:password@dbhost/dbname'
    ```
1. Setup the database and tables.
    ```sh
    bundle exec rake access_token_db:create access_token_db:migrate
    ```
1. Add the following line in `app_config.rb` to use DB cache.
    ```ruby
    AccessTokenProxy.use :db_cache
    ```
1. Start the server-side application with `ACCESS_TOKEN_DB_URL`.
