require 'spec_helper'
require 'user/user'

describe Azure::DocumentDB::User do
  let(:user_name) { "user_name" }
  let(:user_id) { "OGk0AFNSCgA=" }
  let(:database_id) { "0EWFAA==" }
  let(:url) { "our_url" }
  let(:resource_type) { "users" }
  let(:users_url) { "#{url}/dbs/#{database_id}/#{resource_type}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme } # We will inject module RestClient for testability
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:default_header) { "default_header" }
  let(:default_header_with_signed_id) { "default_header_with_id" }
  let(:user_record) {
    { "id"=>user_name, "_rid"=>user_id, "_ts"=>1408232724, "_self"=>"dbs\/OGk0AA==\/users\/OGk0AFNSCgA=\/", "_etag"=>"00003000-0000-0000-0000-53efed140000", "_permissions"=>"permissions\/" }
  }

  let(:list_result) { {"_rid"=>database_id, "Users"=>[user_record], "_count" => 1 } }

  let(:create_body) { { "id" => user_name } }

  let(:user) { Azure::DocumentDB::User.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(context).service_version { serv_version }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get", database_id) { default_header_with_signed_id }
    give(rest_client).get(users_url, default_header_with_signed_id) { list_result.to_json }
  }

  it "can list the existing databases" do
    expect(user.list database_id).to eq list_result
  end
end
