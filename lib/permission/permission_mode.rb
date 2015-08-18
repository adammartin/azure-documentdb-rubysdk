module Azure
  module DocumentDB
    module Permissions
      class Mode
        class << self
          attr_reader :ALL, :READ
        end

        private

        @ALL = 'All'.freeze
        @READ = 'Read'.freeze
      end
    end
  end
end
