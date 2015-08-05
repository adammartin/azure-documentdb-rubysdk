require_relative 'index_path'
require 'json'

module Azure
  module DocumentDB
    class IndexingMode
      class << self
        attr_reader :CONSISTENT, :LAZY
      end

      private
      @CONSISTENT = "consistent".freeze
      @LAZY = "lazy".freeze
    end

    class IndexPolicy
      def initialize automatic, indexing_mode, include_paths, exclude_paths
        self.policy = { "automatic"=>automatic, "indexingMode"=>indexing_mode, "IncludePaths"=> paths_body(include_paths), "ExcludePaths" => paths_body(exclude_paths) }
      end

      def body
        policy.to_json
      end

      private
      attr_accessor :policy

      def paths_body paths
        paths.map do |path| path.body end
      end
    end
  end
end
