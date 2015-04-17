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
        service_header = header Time.now.httpdate, "accept", "get"
        header = Azure::DocumentDB::Header.new.generate ["x-ms-version"], service_header
        JSON.parse(rest_client.get url, header)
      end

      def create database_name
        body = { "id" => database_name }
        service_header = header Time.now.httpdate, "Content-Type", "post"
        header = Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], service_header
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def header time, content, verb
        signed_auth = context.master_token.generate verb, resource_type, "", time
        { content => "application/json", "x-ms-date" => time, "authorization" => signed_auth }
      end

      def url
        "#{context.endpoint}/#{resource_type}"
      end
    end
  end
end
