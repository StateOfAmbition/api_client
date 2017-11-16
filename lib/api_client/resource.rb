module Api
  module Client
    class Resource
      attr_reader :data, :type, :id, :attributes

      def self.parse(document)
        data = document["data"]

        if data.is_a? Array
          data.collect{|d| new(d)}
        elsif data.is_a? Hash
          [new(data)]
        else
          puts "[Api::Client::Resource.parse] document data is not an Array or Hash: #{data.class.name} #{data.inspect}"
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