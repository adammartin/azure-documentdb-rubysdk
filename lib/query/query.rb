require_relative 'query_param'
require_relative 'query_request'
require_relative '../context'
require_relative '../header/secure_header'
require_relative '../auth/master_token'

module Azure
  module DocumentDB
    class Query
      def initialize context, rest_client, resource_type, parent_resource_id, uri
        self.context = context
        self.rest_client = rest_client
        self.resource_type = resource_type
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
        self.parent_resource_id = parent_resource_id
        self.url = uri
      end

      def execute query_request
        header = query_request.header secure_header, parent_resource_id
        parse_results query_request, rest_client.post(url, query_request.body.to_json, header)
      end

      private

      attr_accessor :context, :rest_client, :resource_type, :secure_header, :parent_resource_id, :url

      def parse_results query_request, response
        result = { :header => response.headers, :body => JSON.parse(response.body) }
        update_result_with_next_request query_request, response, result
      end

      def update_result_with_next_request query_request, response, result
        return result unless response.headers[:x_ms_continuation]
        query_request.custom_query_header.continuation_token response.headers[:x_ms_continuation]
        result[:next_request] = query_request
        result
      end
    end
  end
end
