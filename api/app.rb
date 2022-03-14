# frozen_string_literal: true

require 'json'
require 'logger'
require 'sinatra'
require 'access_token_proxy'
require_relative 'auth_phone_methods'

AccessTokenProxy.config = {
  tenant: ENV['MSGRAPH_TENANT'], client_id: ENV['MSGRAPH_CLIENT_ID']
}.merge(
  (ENV.key?('MSGRAPH_CLIENT_ASSERTION') &&
    { assertion: ENV['MSGRAPH_CLIENT_ASSERTION'] }) ||
  (ENV.key?('MSGRAPH_CLIENT_SECRET') &&
    { secret: ENV['MSGRAPH_CLIENT_SECRET'] })
)

# Sinatra app class
class App < Sinatra::Base
  class << self
    attr_accessor :normalize_upn, :normalize_number, :verify_upn

    def graph_logger
      AuthPhoneMethods.logger
    end

    def graph_logger=(logger)
      AuthPhoneMethods.logger = logger
    end
  end

  @verify_upn = ->(upn, env) { upn == env['REMOTE_USER'] }
  @normalize_upn = ->(upn) { upn }
  @normalize_number = ->(number) { number }

  def verify_upn(upn, env)
    self.class.verify_upn.call(upn, env)
  end

  def normalize_upn(upn)
    self.class.normalize_upn.call(upn)
  end

  def normalize_number(number)
    self.class.normalize_number.call(number)
  end

  configure do
    set :environment, (ENV['APP_ENV'] || :production).to_sym
    set :default_content_type, :json
  end

  helpers do
    def parse_params
      @params = JSON.parse(request.body.read, symbolize_names: true)
      unless verify_upn(@params[:UPN], env)
        halt 403, { error: { type: 'UPN_verification_failed' } }.to_json
      end
      @params[:UPN] = normalize_upn(@params[:UPN])
      @params[:number] &&= normalize_number(@params[:number])
    end
  end

  post '/check' do
    parse_params
    result = AuthPhoneMethods.check(@params[:UPN])
    if result
      result.to_json
    else
      halt 403, { error: { type: 'No_registered_method' } }.to_json
    end
  end

  post '/commit' do
    parse_params
    AuthPhoneMethods.commit(*@params.values_at(:action, :UPN, :number, :type))
    params.to_json
  end

  error do
    e = env['sinatra.error']
    response =
      case e
      when OpenSSL::OpenSSLError
        { type: 'Graph_SSL_Error' }
      when MSGraph::Error
        if e.body.is_a?(Hash) && e.body.key?(:error)
          { type: 'Graph_Error', detail: e.body[:error] }
        else
          { type: 'Graph_Error', detail: e.body }
        end
      else
        { type: 'Unknown', detail: e.message }
      end
    { error: response }.to_json
  end
end
