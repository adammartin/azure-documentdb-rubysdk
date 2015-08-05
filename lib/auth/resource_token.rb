require 'erb'

module Azure
  module DocumentDB
    class ResourceToken
      def initialize permission_record
        self.encoded_token = ERB::Util.url_encode permission_record["_token"]
      end

      def encode
        encoded_token
      end

      private
      attr_accessor :encoded_token
    end
  end
end
