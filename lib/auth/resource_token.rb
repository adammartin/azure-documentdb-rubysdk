require 'erb'

module Azure
  module DocumentDB
    class ResourceToken
      def initialize permission_record
        self.encoded_token = ERB::Util.url_encode permission_record['_token']
      end

      def encode_header
        hash = { 'x-ms-date' => Time.now.httpdate, 'authorization' => encoded_token }
        Azure::DocumentDB::Header.new.generate ['User-Agent', 'x-ms-version'], hash
      end

      private

      attr_accessor :encoded_token
    end
  end
end
