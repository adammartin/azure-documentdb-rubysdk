require 'json'
require_relative '../header/secure_header'
require_relative 'index_policy'

module Azure
  module DocumentDB
    class Collection
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "colls"
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list database_id
        url = url database_id
        header = secure_header.header "get", database_id
        JSON.parse(rest_client.get url, header)
      end

      def create database_id, collection_name, policy = nil
        url = url database_id
        body = { "id" => collection_name }
        body["IndexPolicy"] = policy.body if policy
        header = secure_header.header "post", database_id
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def get database_id, collection_id
        url = url database_id, collection_id
        header = secure_header.header "get", collection_id
        JSON.parse(rest_client.get url, header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header

      def url database_id, resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{resource_type}#{target}"
      end
    end
  end
end
