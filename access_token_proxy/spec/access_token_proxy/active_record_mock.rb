# frozen_string_literal: true

require 'active_record'

module AccessTokenProxy
  module ActiveRecord
    # mocked ActiveRecord::Base
    class Base < ::ActiveRecord::Base
      attr_accessor :expire, :type, :value, :scope

      def self.establish_connection(_arg); end

      def save!
        true
      end

      def update!(attributes)
        assign_attributes(attributes)
      end
    end
  end
end
