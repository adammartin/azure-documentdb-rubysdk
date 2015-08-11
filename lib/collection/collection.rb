require 'json'
require_relative '../context'
require_relative '../header/secure_header'
require_relative '../auth/resource_token'
require_relative 'index_policy'

module Azure
  module DocumentDB
    class Collection
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = Azure::DocumentDB::ResourceType.COLLECTION
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list database_id, resource_token = nil
        url = url database_id
        header = header "get", database_id, resource_token
        JSON.parse(rest_client.get url, header)
      end

      def create database_id, collection_name, policy = nil
        url = url database_id
        body = { "id" => collection_name }
        body["IndexPolicy"] = policy.body if policy
        header = header "post", database_id
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def get database_id, collection_id, resource_token = nil
        url = url database_id, collection_id
        header = header "get", collection_id, resource_token
        JSON.parse(rest_client.get url, header)
      end

      def delete database_id, collection_id, resource_token = nil
        url = url database_id, collection_id
        header = header "delete", collection_id, resource_token
        rest_client.delete url, header
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header

      def url database_id, resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{resource_type}#{target}"
      end

      def header verb, resource_id, resource_token = nil
        return secure_header.header verb, resource_id unless resource_token
        resource_token.encode_header
      end
    end
  end
end
