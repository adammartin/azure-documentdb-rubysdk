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
        header = header "get"
        JSON.parse(rest_client.get url, header)
      end

      def get database_id
        header = header "get", database_id
        get_url = url database_id
        JSON.parse(rest_client.get get_url, header)
      end

      def create database_name
        body = { "id" => database_name }
        header = header "post"
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      def delete database_id
        header = header "delete", database_id
        delete_url = url database_id
        rest_client.delete delete_url, header
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def httpdate
        Time.now.httpdate
      end

      def header verb, resource_id = ""
        time = httpdate
        signed_auth = signed_auth time, verb, resource_id
        hash = { "x-ms-date" => time, "authorization" => signed_auth }
        Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], hash
      end

      def signed_auth time, verb, resource_id
        context.master_token.generate verb, resource_type, resource_id, time
      end

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/#{resource_type}#{target}"
      end
    end
  end
end
