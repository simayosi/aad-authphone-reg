# frozen_string_literal: true

require 'access_token_proxy'

module AccessTokenProxy # rubocop:disable Style/Documentation
  # Access token proxy with memory cache
  class Memcache < Backend
    def token(scope)
      validate(memcache[scope]) || memcache[scope] = retrieve_token(scope)
    end

    private

    def retrieve_token(id)
      acquire_token(id)
    end

    def memcache
      @memcache ||= {}
    end
  end

  def self.create_memcache
    Memcache.new
  end
end
