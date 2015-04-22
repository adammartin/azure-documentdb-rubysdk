require 'json'
require_relative '../header/secure_header'

module Azure
  module DocumentDB
    class User
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "users"
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list database_id
        url = url database_id
        header = secure_header.header "get", database_id
        JSON.parse(rest_client.get url, header)
      end

      def create database_id, user_name
        url = url database_id
        body = { "id" => user_name }
        header = secure_header.header "post", database_id
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def get database_id, user_id
        url = url database_id, user_id
        header = secure_header.header "get", user_id
        JSON.parse(rest_client.get url, header)
      end

      def delete database_id, user_id
        url = url database_id, user_id
        header = secure_header.header "delete", user_id
        rest_client.delete url, header
      end

      def replace database_id, user_id, user_name
        url = url database_id, user_id
        body = { "id" => user_name }
        header = secure_header.header "put", user_id
        JSON.parse(rest_client.put url, body.to_json, header)
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
