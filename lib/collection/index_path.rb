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

    class DefaultPath
      def initialize path, index_type
        self.path = {"Path" => path, "indexType" => index_type}
      end

      def body
        path.to_json
      end

      private
      attr_accessor :path
    end

    class IndexPath < DefaultPath
      def numeric_precision precision
        validate precision
        path["NumericPrecision"] = precision
      end

      def string_precision precision
        validate precision
        path["StringPrecision"] = precision
      end

      def self.ROOT_PATH
        DefaultPath.new "\/", IndexType.HASH
      end

      def self.TS_PATH
        DefaultPath.new "/\"_ts\"/?", IndexType.RANGE
      end

      def validate precision
        raise ArgumentError.new "Precision of #{precision} is outside range of 1 to 7." unless precision.between?(1,7)
      end
    end
  end
end
