# frozen_string_literal: true

require 'client_creds'

# Access token proxy
module AccessTokenProxy
  # Abstract class for proxy backends
  class Backend
    include AccessTokenProxy

    def token(_scope)
      raise '#token not implemented.'
    end

    private

    def validate(token)
      token if token&.valid? in: 1
    end

    def acquire_token(scope)
      token = client_creds.get_token(scope)
      yield token if block_given?
      token
    end

    def client_creds
      raise 'AccessTokenProxy not configured!' unless AccessTokenProxy.config

      @client_creds ||= ClientCreds.new(**AccessTokenProxy.config)
    end
  end

  class << self
    attr_accessor :config

    # Set the backend
    def use(backend)
      @backend = backend
      @instance = nil
    end

    # Get a valid token.
    def token(scope)
      instance.token(scope)
    end

    private

    def instance
      @instance ||= create_instance
    end

    def create_instance
      require "access_token_proxy/#{backend}"
      public_send("create_#{backend}")
    end

    def backend
      @backend ||= :memcache
    end
  end
end
