# frozen_string_literal: true

require 'active_record'

module AccessTokenProxy
  # Active record model for cached tokens
  class CachedToken < ActiveRecord::Base
    self.inheritance_column = :inheritance

    establish_connection(ENV['ACCESS_TOKEN_DB_URL'])
  end
end
