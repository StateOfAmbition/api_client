module Api
  module Client
    module Http
      def self.included(base)

        def delete(path)
          authenticate do
            request("#{base_endpoint}/#{path}", {}, :delete)
          end
        end

        def get(path, params={})
          authenticate do
            path = "#{base_endpoint}/#{path}"
            path = params.empty? ? path : "#{path}?#{params.join("&")}"
            request("#{base_endpoint}/#{path}")
          end
        end

        def post(path, params={})
          authenticate do
            request("#{base_endpoint}/#{path}", params, :post)
          end
        end

        def patch(path, params={})
          authenticate do
            request("#{base_endpoint}/#{path}", params, :patch)
          end
        end

        def request(url='', params = {}, action= :get)
          begin
            Api::Client.logger.info "[API::Client##{action} Request] url: #{url} params: #{params}"
            attributes = non_post_method?(action) ? [url, header_params] : [url, params, header_params]
            response = RestClient.send(action, *attributes)
            parse(response)
          rescue RestClient::ExceptionWithResponse => e
            Api::Client.logger.info "[API::Client##{action}] ERROR: #{e.inspect} #{e.response.request.url} #{header_params.inspect} #{params.inspect} #{e.response.body}"
            parse(e.response)
          rescue Exception => e
            Api::Client.logger.info "[API::Client##{action}] ERROR: #{e.inspect}"
            raise e
          end
        end

        def parse(response)
          begin
            document = JSON.parse(response.body)
            Response.new(response.code, response.headers, Resource.parse(document, :data), Resource.parse(document, :included)).tap do |r|
              Api::Client.logger.info "[API::Client] Response: status #{r.status} data: #{r.data.inspect}" if log_response?
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

          def log_response?
            Api::Client.config.logger_active
          end
      end
    end
  end
end
