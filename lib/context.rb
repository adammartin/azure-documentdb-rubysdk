require_relative 'auth/master_token'
require_relative 'version/version'

module Azure
  module DocumentDB
    # rubocop:disable Style/VariableName, Lint/UselessAccessModifier
    class ResourceType
      class << self
        attr_reader :COLLECTION, :DOCUMENT, :DATABASE, :USER, :PERMISSION, :OFFER
      end

      private

      @COLLECTION = 'colls'.freeze
      @DOCUMENT = 'docs'.freeze
      @DATABASE = 'dbs'.freeze
      @USER = 'users'.freeze
      @PERMISSION = 'permissions'.freeze
      @OFFER = 'offers'.freeze
    end
    # rubocop:enable Style/VariableName, Lint/UselessAccessModifier

    class Context
      def initialize service_endpoint, master_key
        self.endpoint = service_endpoint
        self.master_token = Azure::DocumentDB::MasterToken.new master_key
        self.service_version = Azure::DocumentDB::SERVICE_VERSION
      end

      attr_accessor :endpoint, :master_token, :service_version
    end
  end
end
