module Api
  module Client
    class Response
      attr_reader :status, :data

      def initialize(status, data)
        @status = status
        @data = data
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
        @resource ||= data.is_a?(Array) ? data.first : nil
      end
    end
  end
end