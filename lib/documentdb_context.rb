require_relative 'auth/master_token'

module Azure
  class DocumentDBContext
    def initialize service_endpoint, master_key
      self.endpoint = service_endpoint
      self.master_token = Azure::MasterToken.new master_key
    end

    attr_accessor :endpoint, :master_token
  end
end
