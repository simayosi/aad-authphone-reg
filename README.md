# AAD-AuthPhone-Reg

Web app for registering user phone numbers
for Multi-Factor Authentication in Azure Active Directory _externally_.


## Overview

This app allows users to add a phone number for MFA without MFA.

This app consists of a frontend application and REST API endpoints.  
The frontend application, running on user browsers, is
coded in JavaScript (ES6: ECMAScript 2015)
using [React](https://reactjs.org).  
The REST API endpoints are provided by a server-side application
implemented in Ruby using [Sinatra](http://sinatrarb.com),
which calls Microsoft Graph API to add and update a phone number to a user.


## Requirements

**Caution:**
_You MUST protect this app with some user authentication
by means other than Azure AD._

#### Client
- Web browsers supporting ES6

#### Server (REST API)
- Ruby >= 2.7

#### To build
- Node.js >= 14.0.0


## Prerequisites

Register an application in the Azure portal
and grant it `UserAuthenticationMethod.ReadWrite.All` permission,
for the server-side applicaiton to access Microsoft Graph API.  
You need either a certificate assertion or a client secret
as a credential for application authentication.  
For computing a client assertion for a certificate,
you can use `msidp-cert2assertion` command in [msidp-endpoint gem](https://rubygems.org/gems/msidp-endpoint).  
See Microsoft documents, for details of application registration.

Ref:
- [Quickstart: Register an application with the Microsoft identity platform](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
- [Quickstart: Configure a client application to access a web API](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis)


## Getting Started
1. Checkout this repository.
    ```sh
    git clone https://github.com/simayosi/aad-authphone-reg
    cd aad-authphone-reg
    ```
1. Build the frontend application.
    ```sh
    cd app; yarn build
    ```
1. Upload files under `app/build` to your web server.
1. Upload files under `api` to your web server.
1. Install required ruby gems in the directory you copied `api` on your server.
    ```sh
    bundle install
    ```
1. Configure your web server to route `/api` to the port `9292`.
1. Start the server-side application as an HTTP server with required environment variables.
    ```sh
    export MSGRAPH_TENANT=yourtenant.onmicrosoft.com    # tenant ID
    export MSGRAPH_CLIENT_ID=client_ID      # assigned application (client) ID
    export MSGRAPH_CLIENT_ASSERTION=JWT_assertion_string    # in certificate assertion case
    export MSGRAPH_CLIENT_SECRET=client_secret  # in client secret case
    bundle exec rackup
    ```
1. Start your web server.

### Sample configuration for using basic authentication with nginx

This sample is for test purposes only.

Create `app_config.rb` file in `api` directory on your server.
```ruby
app.use Rack::Auth::Basic do true end
```

Configure your nginx.
```
http {
    server {
        ...
        location / {
            root   /path/to/uploaded/build/directory;
            index  index.html;
            auth_basic "Authentication required";
            auth_basic_user_file htpasswd;
        }
        ...
        location /api/ {
            proxy_pass http://localhost:9292/;
        }
    }
}
```


## Configuration & Customization

See [app/README.md](app/README.md) and [api/README.md](api/README.md).
