require 'json'
require_relative '../context'
require_relative '../header/secure_header'
require_relative '../query/query'

module Azure
  module DocumentDB
    class Offer
      def initialize context, rest_client
        self.context = context
        self.rest_client = rest_client
        self.resource_type = Azure::DocumentDB::ResourceType.OFFER
        self.secure_header = Azure::DocumentDB::SecureHeader.new context.master_token, resource_type
      end

      def list
        header = secure_header.header "get"
        JSON.parse(rest_client.get url, header)
      end

      def get offer_id
        url = url offer_id
        header = secure_header.header "get", offer_id
        JSON.parse(rest_client.get url, header)
      end

      def replace offer_id, new_offer
        url = url offer_id
        header = secure_header.header "put", offer_id
        JSON.parse(rest_client.put url, new_offer, header)
      end

      def query
        Azure::DocumentDB::Query.new context, rest_client, resource_type, '', url
      end

      def uri
        url
      end

      private
      attr_accessor :context, :rest_client, :resource_type, :secure_header

      def url resource_id = nil
        target = "/" + resource_id if resource_id
        "#{context.endpoint}/#{resource_type}#{target}"
      end
    end
  end
end
