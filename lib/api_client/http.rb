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
            attributes = action.eql?(:get) ? [url, authorization_params] : [url, params, authorization_params]
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
            data = JSON.parse(body)
            Response.new(status, Resource.parse(data))
          rescue JSON::ParserError => e
            body
          end
        end

        def authorization_params
          {accept: 'application/vnd.api+json', Authorization: "Bearer #{access_token}"}
        end
      end
    end
  end
end
