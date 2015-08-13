require 'time'
require_relative '../header/header'

module Azure
  module DocumentDB
    class SecureHeader
      def initialize token, resource_type
        self.token = token
        self.resource_type = resource_type
      end

      def header verb, resource_id = ""
        time = httpdate
        signed_auth = signed_auth time, verb, resource_id
        hash = { "x-ms-date" => time, "authorization" => signed_auth }
        Azure::DocumentDB::Header.new.generate ["x-ms-version"], hash
      end

      private
      attr_accessor :token, :resource_type

      def signed_auth time, verb, resource_id
        token.generate verb, resource_type, resource_id, time
      end

      def httpdate
        Time.now.httpdate
      end
    end
  end
end
