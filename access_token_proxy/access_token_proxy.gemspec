# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'access_token_proxy'
  spec.version = '0.1.0'
  spec.authors = ['SHIMAYOSHI, Takao']
  spec.email = ['simayosi@cc.kyushu-u.ac.jp']

  spec.summary = 'AccessTokenProxy'
  spec.description = 'Access token proxy using Active Record.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.files = Dir['lib/**/*', 'db/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'msidp-endpoint'
end
