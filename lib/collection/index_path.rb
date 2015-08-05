require 'json'

module Azure
  module DocumentDB
    class IndexType
      class << self
        attr_reader :HASH, :RANGE
      end

      private
      @HASH = "Hash".freeze
      @RANGE = "Range".freeze
    end

    class IndexPath
      def initialize path, index_type
        self.path = {"Path" => path, "indexType" => index_type}
      end

      def body
        path.to_json
      end

      def numeric_precision precision
        validate precision
        path["NumericPrecision"] = precision
      end

      def string_precision precision
        validate precision
        path["StringPrecision"] = precision
      end

      def self.ROOT_PATH
        @@root_path ||= IndexPath.new "\/", IndexType.HASH
      end

      def self.TS_PATH
        @@ts_path ||= IndexPath.new "/\"_ts\"/?", IndexType.RANGE
      end

      private
      attr_accessor :path

      def validate precision
        raise ArgumentError.new "Precision of #{precision} is outside range of 1 to 7." unless precision.between?(1,7)
      end
    end
  end
end
