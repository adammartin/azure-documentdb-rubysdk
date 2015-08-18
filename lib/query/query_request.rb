require_relative 'query_param'
require_relative '../header/custom_query_header'
require_relative '../header/secure_header'

module Azure
  module DocumentDB
    class QueryRequest
      def initialize query_string
        self.query_string = query_string
        self.query_string.freeze
        self.custom_query_header = Azure::DocumentDB::CustomQueryHeader.new
        self.parameters = Azure::DocumentDB::QueryParameter.new
      end

      attr_reader :query_string, :custom_query_header, :parameters

      def header secure_header, parent_resource_id
        raw_header = secure_header.header 'post', parent_resource_id
        custom_query_header.header raw_header
      end

      def body
        { :query => query_string, :parameters => parameters.params }
      end

      private

      attr_writer :query_string, :custom_query_header, :parameters
    end
  end
end
