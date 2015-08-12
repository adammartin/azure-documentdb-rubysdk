require 'json'
require 'time'
require_relative '../context'
require_relative '../header/secure_header'

module Azure
  module DocumentDB
    class Database
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = Azure::DocumentDB::ResourceType.DATABASE
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list
        header = secure_header.header "get"
        JSON.parse(rest_client.get url, header)
      end

      def get database_id
        header = secure_header.header "get", database_id
        get_url = url database_id
        JSON.parse(rest_client.get get_url, header)
      end

      def create database_name
        body = { "id" => database_name }
        header = secure_header.header "post"
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def delete database_id
        header = secure_header.header "delete", database_id
        delete_url = url database_id
        rest_client.delete delete_url, header
      end

      def uri
        url
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/#{resource_type}#{target}"
      end
    end
  end
end
