# frozen_string_literal: true

require './app'

warmup do |app|
  config_file = 'app_config.rb'
  if FileTest.exist?(config_file)
    eval(File.read(config_file), binding, config_file)
  end
end

run App
