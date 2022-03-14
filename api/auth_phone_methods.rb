# frozen_string_literal: true

require 'singleton'
require 'logger'
require 'msgraph/client'
require 'access_token_proxy'

# Class for calling Graph API
module AuthPhoneMethods
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stderr)
    end

    def check(upn)
      path = "/beta/users/#{upn}/authentication/methods"
      value = call_graph(:get, path)[:value]

      return nil if value.none? { |m| !password_auth?(m) }

      types = value.map { |m| m[:phoneType] }.compact
      type = PHONE_TYPES.find { |t| !types.include?(t) }
      if type
        { type: type, action: 'add' }
      else
        { type: 'alternateMobile', action: 'update' }
      end
    end

    def commit(action, upn, number, type)
      params = { phoneNumber: number, phoneType: type }
      case action
      when 'add'
        command = :post
        path = "/beta/users/#{upn}/authentication/phoneMethods"
      when 'update'
        command = :put
        path =
          "/beta/users/#{upn}/authentication/phoneMethods/#{TYPE_ID[type]}"
      else
        raise ArgumentError, 'Illegal action specified'
      end

      call_graph(command, path, params)
    end

    private

    PHONE_TYPES = %w[mobile alternateMobile office].freeze
    TYPE_ID = {
      'mobile' => '3179e48a-750b-4051-897c-87b9720928f7',
      'alternateMobile' => 'b6332ec1-7057-4abe-9331-3d72feddfe41',
      'office' => 'e37fc753-ff3b-4958-9484-eaa9425c82bc'
    }.freeze
    private_constant :PHONE_TYPES, :TYPE_ID

    def call_graph(command, path, data = nil)
      logstr = +"#{command.to_s.upcase} #{path}"
      logstr << " #{data.reject { |k| k == :phoneNumber }.to_json}" if data
      logger.info(logstr)
      graph_client.request(command, path, token, data)
    rescue StandardError => e
      logger.error(e.message)
      raise
    end

    def password_auth?(method)
      method[:'@odata.type'] == '#microsoft.graph.passwordAuthenticationMethod'
    end

    def graph_client
      @graph_client ||= MSGraph::Client.new
    end

    def token
      AccessTokenProxy.token(MSGraph::SCOPE)
    end
  end
end
