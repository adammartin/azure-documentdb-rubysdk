require 'spec_helper'
require 'permission/permission'

describe Azure::DocumentDB::Permission do
  let(:url) { "our_url" }
  let(:resource_type) { "permissions" }
  let(:database_id) { "dbs_name" }
  let(:user_type) { "users" }
  let(:user_id) { "user_id" }
  let(:permission_url) { "#{url}/dbs/#{database_id}/#{user_type}/#{user_id}/#{resource_type}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:coll_name) { "collection_name" }
  let(:perm_mode) { "permission_mod" }
  let(:perm_id) { "perm_id" }
  let(:permission_record) { { "id" => coll_name, "permissionMode" => perm_mode, "_rid" => perm_id} }

  let(:list_header) { "list_header" }
  let(:list_result) { { "_rid" => user_id, "Permissions" => [permission_record], "_count" => 1 } }

  let(:permission) { Azure::DocumentDB::Permission.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get", user_id) { list_header }
    give(rest_client).get(permission_url, list_header) { list_result.to_json }
  }

  it "can list the existing permissions for a database for a given user" do
    expect(permission.list database_id, user_id).to eq list_result
  end
end
