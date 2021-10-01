module Api
  module Client
    module Core
      def self.included(base)
        attr_reader :base_endpoint, :client_id, :client_secret
        attr_accessor :access_token_expires_at, :access_token

        def initialize(config={})
          config = default_config.merge(config)

          # Set up the variables
          config.each do |var_name, var_value|
            instance_variable_set("@#{var_name}",var_value) if self.respond_to?(var_name)
          end
        end

        def authenticate
          access_token.nil? || token_expired? ? generate_token : access_token
          block_given? ? yield(access_token) : access_token
        end

        def token_expired?
          access_token_expires_at.nil? || (access_token_expires_at && access_token_expires_at < Time.now)
        end

        def generate_token
          raise "api client must implement #generate_token"
        end

        def access_token
          @access_token || Api::Client.access_token
        end

        def base_endpoint
          @base_endpoint || Api::Client.base_endpoint
        end

        def verify_ssl
          @verify_ssl || Api::Client.verify_ssl
        end

        private

          def default_config
            {}
          end

      end
    end
  end
end
