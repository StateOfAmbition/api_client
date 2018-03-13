require "rest-client"
require "json"
require "logger"

require_relative './api_client/response.rb'
require_relative './api_client/resource.rb'
require_relative './api_client/base.rb'
require_relative './api_client/configuration.rb'

module Api
  module Client


    def self.config
      @@config ||= Api::Client::Configuration.new
    end

    def self.setup
      yield config
    end

    def self.logger
      @logger ||= logger = Logger.new(STDOUT).tap do |l|
        l.level = Logger::INFO
      end
    end

    def self.method_missing(name, *args)
      config.send(name) if config.respond_to?(name)
    end

    extend self
  end
end
