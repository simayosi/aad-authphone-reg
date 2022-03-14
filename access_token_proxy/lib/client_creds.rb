# frozen_string_literal: true

require 'msidp/endpoint'

# OAuth 2.0 client credentials grant for Microsoft identity platform.
class ClientCreds
  include MSIDP::Endpoint

  # Creates a new client.
  # Either +secret+ or +assertion+ keyword parameter is mandatory.
  #
  # @param [String] tenant the directory tenant in GUID or domain-name format.
  # @param [String] client_id the assigned client ID.
  # @param [String] secret the client secret generated in the app
  #     registration portal.
  # @param [String] assertion an assertion (a JSON web token) that is signed
  #     with the certificate registered as credentials.
  def initialize(tenant:, client_id:, secret: nil, assertion: nil)
    unless secret || assertion
      raise ArgumentError,
            'Either secret or assertion must be specified!'
    end

    @uri = token_uri(tenant)
    @params = {
      client_id: client_id, grant_type: 'client_credentials'
    }
    if assertion
      @params[:client_assertion_type] =
        'urn:ietf:params:oauth:client-assertion-type:jwt-bearer'
      @params[:client_assertion] = assertion
    else
      @params[:client_secret] = secret
    end
  end

  # Acquires an access token.
  #
  # @param [String] scope the resource identifier (application ID URI) of the
  #     target resource, suffixed with `.default`.
  # @return [MSIDP::ClientCreds::AccessToken] an access token
  def get_token(scope)
    token(@uri, @params.merge({ scope: scope }))
  end
end
