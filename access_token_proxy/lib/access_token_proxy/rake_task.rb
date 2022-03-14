# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'active_record'

module AccessTokenProxy
  # Rake tasks for access token database.
  class RakeTask < ::Rake::TaskLib
    # Name of ns_name. Defaults to `:access_token_db`.
    attr_accessor :ns_name

    def initialize(ns_name = :access_token_db)
      super()
      @ns_name = ns_name
      define
    end

    private

    def define
      rakefile = File.expand_path('tasks/db.rake', __dir__)
      instance_eval(IO.read(rakefile), rakefile, 1)
    end
  end
end
