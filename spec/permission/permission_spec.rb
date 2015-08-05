require 'spec_helper'
require 'context'
require 'header/secure_header'
require 'auth/master_token'
require 'permission/permission'
require 'permission/permission_definition'
require 'permission/permission_mode'
require 'auth/resource_token'

describe Azure::DocumentDB::Permission do
  let(:url) { "our_url" }
  let(:resource_type) { "permissions" }
  let(:database_id) { "dbs_name" }
  let(:user_type) { "users" }
  let(:user_id) { "user_id" }
  let(:dbs_resource) { "dbs/#{database_id}" }
  let(:permission_list_url) { "#{url}/#{dbs_resource}/#{user_type}/#{user_id}/#{resource_type}" }
  let(:permission_url) { "#{permission_list_url}/#{perm_rid}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:create_permission) { gimme(Azure::DocumentDB::PermissionDefinition) }
  let(:replace_permission) { gimme(Azure::DocumentDB::PermissionDefinition) }
  let(:resource_token) { gimme(Azure::DocumentDB::ResourceToken) }
  let(:perm_name) { "collection_name" }
  let(:perm_mode) { Azure::DocumentDB::Permissions::Mode.ALL }
  let(:perm_rid) { "perm_rid" }
  let(:updated_perm_name) { "updated" }
  let(:permission_record) { { "id" => perm_name, "permissionMode" => perm_mode, "resource" => dbs_resource, "_rid" => perm_rid } }
  let(:updated_perm_record) {
    updated = permission_record.clone
    updated["id"] = updated_perm_name
    updated
  }

  let(:list_header) { "list_header" }
  let(:list_result) { { "_rid" => user_id, "Permissions" => [permission_record], "_count" => 1 } }

  let(:create_header) { "create_header" }
  let(:create_body) { "create_body" }

  let(:get_header) { "get_header" }

  let(:replace_header) { "replace_header" }
  let(:replace_body) { "replace_body" }

  let(:delete_header) { "delete_header" }

  let(:permission) { Azure::DocumentDB::Permission.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(replace_permission).body { replace_body }
    give(create_permission).body { create_body }
    give(secure_header).header("get", user_id) { list_header }
    give(secure_header).header("post", user_id) { create_header }
    give(secure_header).header("put", perm_rid) { replace_header }
    give(secure_header).header("get", perm_rid) { get_header }
    give(secure_header).header("delete", perm_rid) { delete_header }
    give(rest_client).get(permission_list_url, list_header) { list_result.to_json }
    give(rest_client).post(permission_list_url, create_body, create_header) { permission_record.to_json }
    give(rest_client).get(permission_url, get_header) {permission_record.to_json}
    give(rest_client).put(permission_url, replace_body, replace_header) { updated_perm_record.to_json }
    give(Azure::DocumentDB::ResourceToken).new(permission_record) { resource_token }
  }

  it "can list the existing permissions for a database for a given user" do
    expect(permission.list database_id, user_id).to eq list_result
  end

  it "can create a new permission for a given user on a database" do
    expect(permission.create database_id, user_id, create_permission).to eq permission_record
  end

  it "can get a permission for a given user on a database" do
    expect(permission.get database_id, user_id, perm_rid).to eq permission_record
  end

  it "can get a resource_token for a given user on a database" do
    expect(permission.resource_token database_id, user_id, perm_rid).to eq resource_token
  end

  it "can replace an existing permission for a given user on a database" do
    expect(permission.replace database_id, user_id, perm_rid, replace_permission).to eq updated_perm_record
  end

  it "can delete an existing permission for a given user on a database" do
    permission.delete database_id, user_id, perm_rid
    verify(rest_client).delete permission_url, delete_header
  end
end
