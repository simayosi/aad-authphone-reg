# frozen_string_literal: true

namespace @ns_name do
  desc 'Create the database.'
  task :create do
    ActiveRecord::Tasks::DatabaseTasks.create(ENV['ACCESS_TOKEN_DB_URL'])
  end

  desc 'Drop the database.'
  task :drop do
    ActiveRecord::Tasks::DatabaseTasks.drop(ENV['ACCESS_TOKEN_DB_URL'])
  end

  desc 'Migrate the database.'
  task :migrate do
    ActiveRecord::Base.establish_connection(ENV['ACCESS_TOKEN_DB_URL'])
    ActiveRecord::Migrator.migrations_paths =
      [File.expand_path('../../../db/migrate', __dir__)]
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end

  desc 'Reset the database.'
  task reset: ["#{ns_name}:drop", "#{ns_name}:create", "#{ns_name}:migrate"]
end
