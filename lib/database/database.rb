require 'json'
require 'time'
require 'uri'
require_relative '../auth/master_token'
require_relative '../header/header'

module Azure
  module DocumentDB
    class Database
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "dbs"
      end

      def list
        service_header = generic_header "get", "accept"
        header = Azure::DocumentDB::Header.new.generate ["x-ms-version"], service_header
        JSON.parse(rest_client.get url, header)
      end

      def get database_id
        header = header_for_resource_id "get", database_id
        get_url = url database_id
        JSON.parse(rest_client.get get_url, header)
      end

      def create database_name
        body = { "id" => database_name }
        service_header = generic_header "post", "Content-Type"
        header = Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], service_header
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def delete database_id
        header = header_for_resource_id "delete", database_id
        delete_url = url database_id
        rest_client.delete delete_url, header
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def httpdate
        Time.now.httpdate
      end

      def signed_auth time, verb, resource_id = ""
        context.master_token.generate verb, resource_type, resource_id, time
      end

      def header_for_resource_id verb, resource_id
        time = httpdate
        signed_auth = signed_auth time, verb, resource_id
        service_header = header time, signed_auth
        Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], service_header
      end

      def generic_header verb, content
        time = httpdate
        signed_auth = signed_auth time, verb
        header time, signed_auth, content
      end

      def header time, signed_auth, content = nil
        hash = { "x-ms-date" => time, "authorization" => signed_auth }
        hash[content] = "application/json" if content
        hash
      end

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/#{resource_type}#{target}"
      end
    end
  end
end
