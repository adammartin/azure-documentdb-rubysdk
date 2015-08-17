require 'json'
require_relative '../context'
require_relative '../query/query'
require_relative '../header/secure_header'
require_relative '../auth/resource_token'
require_relative '../document/document'
require_relative 'index_policy'

module Azure
  module DocumentDB
    class Collection
      def initialize context, rest_client, database_id
        self.context = context
        self.rest_client = rest_client
        self.database_id = database_id
        self.resource_type = Azure::DocumentDB::ResourceType.COLLECTION
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list resource_token = nil
        header = header "get", database_id, resource_token
        JSON.parse(rest_client.get url, header)
      end

      def create collection_name, policy = nil
        body = { "id" => collection_name }
        body["IndexPolicy"] = policy.body if policy
        header = header "post", database_id
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def get collection_id, resource_token = nil
        url = url collection_id
        header = header "get", collection_id, resource_token
        JSON.parse(rest_client.get url, header)
      end

      def delete collection_id, resource_token = nil
        url = url collection_id
        header = header "delete", collection_id, resource_token
        rest_client.delete url, header
      end

      def query
        Azure::DocumentDB::Query.new context, rest_client, resource_type, database_id, url
      end

      def uri
        url
      end

      def document_for_name collection_name, resource_token = nil
        collection = (list["DocumentCollections"].select do | c | c["id"] == collection_name end)[0]
        raise ArgumentError.new "Collection for supplied name must exist" unless collection
        Azure::DocumentDB::Document.new context, rest_client, database_id, collection["_rid"], resource_token
      end

      def document_for_rid collection_rid, resource_token = nil
        begin
          Azure::DocumentDB::Document.new context, rest_client, database_id, collection_rid, resource_token if get collection_rid, resource_token
        rescue
          raise ArgumentError.new "Collection for supplied id must exist"
        end
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header, :database_id

      def url resource_id = nil
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
