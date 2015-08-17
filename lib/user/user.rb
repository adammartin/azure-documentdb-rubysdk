require 'json'
require_relative '../context'
require_relative '../query/query'
require_relative '../permission/permission'
require_relative '../header/secure_header'

module Azure
  module DocumentDB
    class User
      def initialize context, rest_client, database_id
        self.context = context
        self.rest_client = rest_client
        self.database_id = database_id
        self.resource_type = Azure::DocumentDB::ResourceType.USER
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list
        header = secure_header.header "get", database_id
        JSON.parse(rest_client.get url, header)
      end

      def create user_name
        body = { "id" => user_name }
        header = secure_header.header "post", database_id
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def get user_id
        url = url user_id
        header = secure_header.header "get", user_id
        JSON.parse(rest_client.get url, header)
      end

      def delete user_id
        url = url user_id
        header = secure_header.header "delete", user_id
        rest_client.delete url, header
      end

      def replace user_id, user_name
        url = url user_id
        body = { "id" => user_name }
        header = secure_header.header "put", user_id
        JSON.parse(rest_client.put url, body.to_json, header)
      end

      def permission_for_name user_name
        user = (list["Users"].select do | u | u["id"] == user_name end)[0]
        arg_error "name" unless user
        Azure::DocumentDB::Permission.new context, rest_client, database_id, user["_rid"]
      end

      def permission_for_rid user_rid
        begin
          Azure::DocumentDB::Permission.new context, rest_client, database_id, user_rid if get user_rid
        rescue
          arg_error "resource id"
        end
      end

      def query
        Azure::DocumentDB::Query.new context, rest_client, resource_type, database_id, url
      end

      def uri
        url
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header, :database_id

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{resource_type}#{target}"
      end

      def arg_error reason
        raise ArgumentError.new "User for supplied #{reason} must exist"
      end
    end
  end
end
