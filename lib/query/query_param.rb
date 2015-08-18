module Azure
  module DocumentDB
    class QueryParameter
      def initialize
        self.param_array = []
      end

      def add name, value
        param_array << { :name => name, :value => value }
      end

      def params
        param_array
      end

      private

      attr_accessor :param_array
    end
  end
end
