module Api
  module Client
    module Http
      def self.included(base)

        def delete(path)
          authenticate do
            request("#{base_endpoint}/#{path}", {}, :delete)
          end
        end

        def get(path, payload={})
          authenticate do
            path = payload.empty? ? path : "#{path}?#{payload.map{|k,v| "#{k}=#{v}"}.join('&')}"
            request("#{base_endpoint}/#{path}")
          end
        end

        def post(path, payload={})
          authenticate do
            request("#{base_endpoint}/#{path}", payload, :post)
          end
        end

        def patch(path, payload={})
          authenticate do
            request("#{base_endpoint}/#{path}", payload, :patch)
          end
        end

        def request(url='', payload = {}, action= :get)
          begin
            Api::Client.logger.info "[API::Client##{action} Request] url: #{url} payload: #{payload}" if logger_active?
            attributes = non_post_method?(action) ? {method: action, url: url, header_params: header_params} : {method: action, url: url, payload: payload, header_params: header_params}
            response = RestClient::Request.execute(attributes.merge({verify_ssl: verify_ssl}))
            parse(response)
          rescue RestClient::ExceptionWithResponse => e
            Api::Client.logger.info "[API::Client##{action}] ERROR: #{e.inspect} #{e.response.request.url} #{header_params.inspect} #{payload.inspect} #{e.response.body}"
            parse(e.response)
          rescue Exception => e
            Api::Client.logger.info "[API::Client##{action}] ERROR: #{e.inspect} url: #{url} payload: #{payload}"
            raise e
          end
        end

        def parse(response)
          begin
            document = JSON.parse(response.body)
            Response.new(response.code, response.headers, Resource.parse(document, :data), Resource.parse(document, :included)).tap do |r|
              Api::Client.logger.info "[API::Client] Response: status #{r.status} data: #{r.data.inspect}" if logger_active?
            end
          rescue JSON::ParserError => e
            Response.new(response.code, response.headers, response.body)
          end
        end

        def header_params
          {Authorization: "Bearer #{access_token}"}
        end

        private

          def non_post_method?(action)
            action.eql?(:get) || action.eql?(:delete)
          end

          def logger_active?
            Api::Client.config.logger_active == "true"
          end
      end
    end
  end
end
