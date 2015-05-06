require 'spec_helper'
require 'json'
require 'context'
require 'header/secure_header'
require 'auth/master_token'
require 'permission/permission'

describe Azure::DocumentDB::Permission do
  let(:url) { "our_url" }
  let(:resource_type) { "permissions" }
  let(:database_id) { "dbs_name" }
  let(:user_type) { "users" }
  let(:user_id) { "user_id" }
  let(:dbs_resource) { "dbs/#{database_id}" }
  let(:permission_url) { "#{url}/#{dbs_resource}/#{user_type}/#{user_id}/#{resource_type}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:perm_name) { "collection_name" }
  let(:perm_mode) { Azure::DocumentDB::Permissions::Mode.ALL }
  let(:perm_id) { "perm_id" }
  let(:permission_record) { { "id" => perm_name, "permissionMode" => perm_mode, "resource" => dbs_resource, "_rid" => perm_id } }

  let(:list_header) { "list_header" }
  let(:list_result) { { "_rid" => user_id, "Permissions" => [permission_record], "_count" => 1 } }

  let(:create_header) { "create_header" }
  let(:create_body) { {"id"=>perm_name, "permissionMode" => perm_mode, "resource"=>dbs_resource} }

  let(:permission) { Azure::DocumentDB::Permission.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get", user_id) { list_header }
    give(secure_header).header("post", user_id) { create_header }
    give(rest_client).get(permission_url, list_header) { list_result.to_json }
    give(rest_client).post(permission_url, create_body.to_json, create_header) { permission_record.to_json }
  }

  it "can list the existing permissions for a database for a given user" do
    expect(permission.list database_id, user_id).to eq list_result
  end

  it "can create a new permission for a given user on a database" do
    expect(permission.create database_id, user_id, perm_name, perm_mode, dbs_resource).to eq permission_record
  end
end
