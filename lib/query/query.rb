require_relative 'query_param'
require_relative '../context'
require_relative '../header/secure_header'
require_relative '../header/custom_query_header'
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

      def execute query, custom_query_header, query_params
        raw_header = secure_header.header "post", parent_resource_id
        header = custom_query_header.header raw_header
        request = { :query => query, :parameters => query_params.params }
        response = rest_client.post(url, request.to_json, header)
        { :header => response.headers, :body => JSON.parse(response.body) }
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header, :parent_resource_id, :url
    end
  end
end
