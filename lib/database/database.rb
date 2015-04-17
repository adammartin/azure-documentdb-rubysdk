require 'json'
require 'time'
require 'uri'
require_relative '../auth/master_token'

module Azure
  module DocumentDB
    class Database
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "dbs"
      end

      def list
        header = header Time.now.httpdate, "accept"
        JSON.parse(rest_client.get url, header)
      end

      def create database_name
        body = { "id" => database_name }
        header = header Time.now.httpdate, "content-type"
        header["user-agent"] = "rubysdk/0.0.1"
        JSON.parse(rest_client.post url, body.to_json, header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def header time, content
        signed_auth = context.master_token.generate "get", resource_type, "", time
        { content => "application/json", "x-ms-version" => context.service_version, "x-ms-date" => time, "authorization" => signed_auth }
      end

      def url
        "#{context.endpoint}/#{resource_type}"
      end
    end
  end
end
