require_relative 'auth/master_token'

module Azure
  module DocumentDB
    class Context
      def initialize service_endpoint, master_key
        self.endpoint = service_endpoint
        self.master_token = Azure::DocumentDB::MasterToken.new master_key
      end

      attr_accessor :endpoint, :master_token
    end
  end
end
