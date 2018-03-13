module Api
  module Client
    class Configuration
      attr_accessor :access_token, :base_endpoint, :logger_active

      def logger_active
        @logger_active || false
      end
    end
  end
end
