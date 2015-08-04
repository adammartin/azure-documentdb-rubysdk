require_relative 'permission_mode'

module Azure
  module DocumentDB
    class ReplacePermission
      def initialize perm_id, perm_mode, resource
        self.perm_id = perm_id
        self.perm_mode = perm_mode
        self.resource = resource
      end

      def body
        { "id" => perm_id, "permissionMode"=> perm_mode, "resource"=> resource}.to_json
      end

      private
      attr_accessor :perm_id, :perm_mode, :resource
    end
  end
end
