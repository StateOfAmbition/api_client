module Api
  module Client
    class Configuration
      attr_accessor :access_token, :base_endpoint, :logger_active, :verify_ssl

      def verify_ssl
        @verify_ssl || true
      end

      def logger_active
        @logger_active || false
      end
    end
  end
end
