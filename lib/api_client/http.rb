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
            request("#{base_endpoint}/#{path}", params)
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
            puts "[API::Client##{action} Request] url: #{url} params: #{params}"
            attributes = non_post_method?(action) ? [url, authorization_params] : [url, params, authorization_params]
            response = RestClient.send(action, *attributes)
            parse(response.code, response.body)
          rescue RestClient::ExceptionWithResponse => e
            puts "[API::Client##{action}] ERROR: #{e.inspect} #{e.response.request.url} #{authorization_params.inspect} #{params.inspect} #{e.response.body}"
            parse(e.response.code, e.response.body)
          rescue Exception => e
            puts "[API::Client##{action}] ERROR: #{e.inspect}"
            raise e
          end
        end

        def parse(status, body)
          begin
            document = JSON.parse(body)
            Response.new(status, Resource.parse(document, :data), Resource.parse(document, :included)).tap do |r|
              puts "[API::Client] Response: status #{r.status} data: #{r.data.inspect}" if log_response?
            end
          rescue JSON::ParserError => e
            Response.new(status, body)
          end
        end

        def authorization_params
          {Authorization: "Bearer #{access_token}"}
        end

        private
          def non_post_method?(action)
            action.eql?(:get) || action.eql?(:delete)
          end

          def log_response?
            !Rails.env.production?
          end
      end
    end
  end
end
