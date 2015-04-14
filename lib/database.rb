require 'json'
require 'time'
require 'uri'
require_relative 'auth/master_token'

module Azure
  module DocumentDB
    class Database
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "dbs"
      end

      def list
        header = header Time.now.httpdate
        JSON.parse(rest_client.get "#{context.endpoint}/#{resource_type}", header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type

      def header time
        signed_auth = context.master_token.generate "get", resource_type, "", time
        { "accept" => "application/json", "x-ms-version" => context.service_version, "x-ms-date" => time, "authorization" => signed_auth }
      end
    end
  end
end
