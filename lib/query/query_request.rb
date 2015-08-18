require_relative 'query_param'
require_relative '../header/custom_query_header'

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

      private
      attr_writer :query_string, :custom_query_header, :parameters
    end
  end
end
