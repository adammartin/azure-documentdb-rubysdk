require 'spec_helper'
require 'user/user'
require 'query/query'
require 'permission/permission'

describe Azure::DocumentDB::User do
  let(:user_name) { "user_name" }
  let(:user_id) { "OGk0AFNSCgA=" }
  let(:database_id) { "0EWFAA==" }
  let(:url) { "our_url" }
  let(:resource_type) { "users" }
  let(:users_url) { "#{url}/dbs/#{database_id}/#{resource_type}" }
  let(:target_url) { "#{users_url}/#{user_id}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme } # We will inject module RestClient for testability
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:permission) { gimme(Azure::DocumentDB::Permission) }
  let(:query) { gimme(Azure::DocumentDB::Query) }
  let(:get_header) { "get_header" }
  let(:get_user_header) { "get_user_header" }
  let(:post_header) { "post_header" }
  let(:delete_header) { "delete_header" }
  let(:put_header) { "put_header" }
  let(:user_record) { { "id"=>user_name, "_rid"=>user_id } }

  let(:list_result) { {"_rid"=>database_id, "Users"=>[user_record], "_count" => 1 } }

  let(:create_body) { { "id" => user_name } }
  let(:create_response) { user_record }

  let(:replace_body) { create_body }
  let(:replace_response) { user_record }

  let(:user) { Azure::DocumentDB::User.new context, rest_client, database_id }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(Azure::DocumentDB::Permission).new(context, rest_client, database_id, user_id) { permission }
    give(Azure::DocumentDB::Query).new(context, rest_client, Azure::DocumentDB::ResourceType.USER, database_id, users_url) { query }
    give(secure_header).header("get", database_id) { get_header }
    give(secure_header).header("post", database_id) { post_header }
    give(secure_header).header("get", user_id) { get_user_header }
    give(secure_header).header("delete", user_id) { delete_header }
    give(secure_header).header("put", user_id) { put_header }
    give(rest_client).get(users_url, get_header) { list_result.to_json }
    give(rest_client).post(users_url, create_body.to_json, post_header) { create_response.to_json }
    give(rest_client).get(target_url, get_user_header) { user_record.to_json }
    give(rest_client).put(target_url, replace_body.to_json, put_header) { replace_response.to_json }
  }

  it "can list the existing databases" do
    expect(user.list).to eq list_result
  end

  it "can create a new user" do
    expect(user.create user_name).to eq create_response
  end

  it "can get a user" do
    expect(user.get user_id).to eq user_record
  end

  it "can delete a user" do
    user.delete user_id
    verify(rest_client).delete target_url, delete_header
  end

  it "can replace a user" do
    expect(user.replace user_id, user_name).to eq replace_response
  end

  it "can create a permission for a named user" do
    expect(user.permission_for_name user_name).to eq permission
  end

  it "throws an ArgumentError when supplied a resource name of a user that does not exist when trying to create a permission" do
    expect{ user.permission_for_name "does_not_exist" }.to raise_error ArgumentError, "User for supplied name must exist"
  end

  it "can create a permission for the _rid of a user" do
    expect(user.permission_for_rid user_id).to eq permission
  end

  it "throws an ArgumentError when supplied a resource id of a user that does not exist when trying to create a permission" do
    expect{ user.permission_for_rid "does_not_exist" }.to raise_error ArgumentError, "User for supplied resource id must exist"
  end

  it "can get the uri for the user resource" do
    expect(user.uri).to eq users_url
  end

  it "can create a query for the database object" do
    expect(user.query).to eq query
  end
end
