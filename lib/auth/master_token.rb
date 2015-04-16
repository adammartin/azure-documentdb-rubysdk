require 'erb'
require_relative 'hmac_encoder'

module Azure
  module DocumentDB
    class MasterToken
      def initialize master_key
        self.master_key = master_key
      end

      def generate verb, resource_type, resource_id, rfc7321_date
        type = "master"
        token_version = "1.0"
        text = "#{verb}\n#{resource_type}\n#{resource_id}\n#{rfc7321_date}\n\n"
        signature = Azure::DocumentDB::HMACEncoder.new.encode master_key, text
        ERB::Util.url_encode "type=#{type}&ver=#{token_version}&sig=#{signature}"
      end

      private
      attr_accessor :verb, :resource_id, :resource_type, :master_key
    end
  end
end
