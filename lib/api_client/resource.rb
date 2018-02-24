module Api
  module Client
    class Resource
      attr_reader :data, :includes, :type, :id, :attributes

      def self.parse(document, attribute)
        attribute_data = document[attribute.to_s]

        if attribute_data.is_a? Array
          attribute_data.collect{|d| new(d)}
        elsif attribute_data.is_a? Hash
          [new(attribute_data)]
        else
          []
        end
      end

      def initialize(data)
        @data = data
        @type = @data['type']
        @id = @data['id']
        @attributes = JSON.parse(@data['attributes'].to_json, object_class: OpenStruct)
      end

      def method_missing(method, *args, &block)
        attributes.send(method)
      end
    end
  end
end
