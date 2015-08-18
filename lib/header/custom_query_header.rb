module Azure
  module DocumentDB
    class CustomQueryHeader
      def initialize
        self.header_options = { 'x-ms-documentdb-isquery' => 'True', 'Content-Type' => 'application/query+json', 'Accept' => 'application/json' }
      end

      def header raw_header
        raw_header.merge(header_options)
      end

      def max_items_per_page count
        fail ArgumentError.new 'Max items per page must be between 1 and 1000' unless valid_max_items_per_page? count
        header_options['x-ms-max-item-count'] = count
      end

      def continuation_token token
        fail ArgumentError.new 'x-ms-continuation token must be supplied from previous response' unless token
        header_options['x-ms-continuation'] = token
      end

      def service_version version
        header_options['x-ms-version'] = version
      end

      def enable_scan enable_scan
        fail ArgumentError.new 'Only binary values are allowed for enable scan' unless boolean? enable_scan
        header_options['x-ms-documentdb-query-enable-scan'] = enable_scan
      end

      def session_token token
        header_options['x-ms-session-token'] = token
      end

      private

      attr_accessor :header_options

      def valid_max_items_per_page? count
        count.is_a?(Integer) && count < 1001 && count > 0
      end

      # rubocop:disable Style/DoubleNegation
      def boolean? value
        !!value == value
      end
      # rubocop:enable Style/DoubleNegation
    end
  end
end
