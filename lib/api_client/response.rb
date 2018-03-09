module Api
  module Client
    class Response
      attr_reader :status, :data, :included

      def initialize(status, data, included = [])
        @status = status
        @data = data
        @included = included
      end

      def success
        !error
      end

      def error
        ![200,201].include?(status)
      end

      def resources
        @resources ||= data.is_a?(Array) ? data : []
      end

      def resource
        @resource ||= data.is_a?(Array) ? data.first : data
      end
    end
  end
end
