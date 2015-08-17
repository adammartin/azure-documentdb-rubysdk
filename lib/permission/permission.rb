require 'json'
require_relative '../context'
require_relative '../auth/resource_token'
require_relative '../header/secure_header'
require_relative '../query/query'
require_relative 'permission_mode'
require_relative 'permission_definition'

module Azure
  module DocumentDB
    class Permission
      def initialize context, rest_client, database_id, user_id
        self.context = context
        self.rest_client = rest_client
        self.database_id = database_id
        self.user_id = user_id
        self.resource_type = Azure::DocumentDB::ResourceType.PERMISSION
        self.parent_resource_type = Azure::DocumentDB::ResourceType.USER
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list
        header = secure_header.header "get", user_id
        JSON.parse(rest_client.get url, header)
      end

      def create permission_definition
        header = secure_header.header "post", user_id
        JSON.parse(rest_client.post url, permission_definition.body, header)
      end

      def get permission_rid
        url = url permission_rid
        header = secure_header.header "get", permission_rid
        JSON.parse(rest_client.get url, header)
      end

      def resource_token permission_rid
        Azure::DocumentDB::ResourceToken.new get(permission_rid)
      end

      def replace permission_rid, replace_permission
        url = url permission_rid
        header = secure_header.header "put", permission_rid
        JSON.parse(rest_client.put url, replace_permission.body, header)
      end

      def delete permission_rid
        url = url permission_rid
        header = secure_header.header "delete", permission_rid
        rest_client.delete url, header
      end

      def query
        Azure::DocumentDB::Query.new context, rest_client, resource_type, user_id, url
      end

      def uri
        url
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :parent_resource_type, :secure_header, :database_id, :user_id

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{parent_resource_type}/#{user_id}/#{resource_type}#{target}"
      end
    end
  end
end
