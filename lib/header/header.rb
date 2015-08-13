require_relative '../version/version.rb'

module Azure
  module DocumentDB
    class Header
      def initialize
        self.defaults = { "x-ms-version" => Azure::DocumentDB::SERVICE_VERSION }.freeze
      end

      def generate sdk_default_headers, sdk_specific_headers = {}
        headers = get_defaults sdk_default_headers
        headers.merge sdk_specific_headers
      end

      private
      attr_accessor :defaults

      def get_defaults sdk_default_headers
        defaults.select do | key, value | sdk_default_headers.include? key end
      end
    end
  end
end
