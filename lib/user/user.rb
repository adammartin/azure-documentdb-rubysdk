require 'json'
require 'time'
require 'uri'
require_relative '../auth/master_token'
require_relative '../header/header'

module Azure
  module DocumentDB
    class User
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = "users"
      end

      def list database_id
        url = url database_id
        header = generic_header "get", "accept"
        JSON.parse(rest_client.get url, header)
      end

      private
      attr_accessor :context, :rest_client, :resource_type
      def httpdate
        Time.now.httpdate
      end

      def generic_header verb, content
        time = httpdate
        signed_auth = signed_auth time, verb
        header time, signed_auth, content
      end

      def header time, signed_auth, content = nil
        hash = { "x-ms-date" => time, "authorization" => signed_auth }
        hash[content] = "application/json" if content
        Azure::DocumentDB::Header.new.generate ["User-Agent", "x-ms-version"], hash
      end

      def signed_auth time, verb, resource_id = ""
        context.master_token.generate verb, resource_type, resource_id, time
      end

      def url database_id, resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/dbs/#{database_id}/#{resource_type}#{target}"
      end
    end
  end
end
