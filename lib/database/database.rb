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
        service_header = header httpdate, "get", "accept"
        header = Azure::DocumentDB::Header.new.generate ["x-ms-version"], service_header
        JSON.parse(rest_client.get url, header)
      end

      def create database_name
        body = { "id" => database_name }
        service_header = header httpdate, "post", "Content-Type"
        header = Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], service_header
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def delete database_id
        delete_url = url database_id
        service_header = header httpdate, "delete"
        header = Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], service_header
        rest_client.delete delete_url, header
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def httpdate
        Time.now.httpdate
      end

      def header time, verb, content = nil
        signed_auth = context.master_token.generate verb, resource_type, "", time
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
