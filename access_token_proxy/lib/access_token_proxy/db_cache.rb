# frozen_string_literal: true

require 'access_token_proxy/memcache'
require 'access_token_proxy/cached_token'

module AccessTokenProxy # rubocop:disable Style/Documentation
  # Access token proxy with persistent cache via active record
  class DBCache < Memcache
    private

    def retrieve_token(id)
      validate(cache2token(CachedToken.find_by(id: id))) || store_token(id)
    end

    def store_token(id)
      CachedToken.transaction(isolation: :serializable) do
        cache = CachedToken.lock.find_by(id: id)
        if cache
          validate(cache2token(cache)) ||
            acquire_token(id) { |token| update_cache(cache, token) }
        else
          acquire_token(id) { |token| create_cache(token, id) }
        end
      end
    end

    def cache2token(cache)
      MSIDP::AccessToken.new(cache.value, cache.expire, cache.scope) if cache
    end

    def update_cache(cache, token)
      cache.update!(token2hash(token))
    end

    def create_cache(token, id)
      CachedToken.create!({ id: id }.merge(token2hash(token)))
    end

    def token2hash(token)
      {
        value: token.value, scope: token.scope,
        expire: token.expire, type: token.type
      }
    end
  end

  def self.create_db_cache
    DBCache.new
  end
end
