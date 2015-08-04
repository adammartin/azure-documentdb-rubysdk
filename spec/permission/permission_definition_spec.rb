require 'spec_helper'
require 'permission/permission_definition'
require 'permission/permission_mode'

describe Azure::DocumentDB::PermissionDefinition do
  let(:perm_id) { "perm_id" }
  let(:perm_mode) { Azure::DocumentDB::Permissions::Mode.ALL }
  let(:resource) { "dbs/dbs_name" }
  let(:expected_request) { { "id" => perm_id, "permissionMode"=> perm_mode, "resource"=> resource} }
  let(:replace_permission) { Azure::DocumentDB::PermissionDefinition.new perm_id, perm_mode, resource }

  it "can produce json of replace permission body" do
    expect(replace_permission.body).to eq expected_request.to_json
  end
end
