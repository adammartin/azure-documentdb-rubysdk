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
  let(:time) { gimme(Time) }
  let(:http_date) { "http_date" }
  let(:signed_auth) { "signed_auth" }
  let(:signed_auth_with_id) { "signed_auth_with_id" }
  let(:serv_version) { "2014-08-21" }
  let(:client) { "rubysdk/0.0.1" }
  let(:accept) { "accept" }
  let(:content_type) { "Content-Type" }
  let(:user_record) {
    { "id"=>user_name, "_rid"=>user_id, "_ts"=>1408232724, "_self"=>"dbs\/OGk0AA==\/users\/OGk0AFNSCgA=\/", "_etag"=>"00003000-0000-0000-0000-53efed140000", "_permissions"=>"permissions\/" }
  }
  let(:default_header) {
    {"User-Agent" => client, "x-ms-date" => http_date, "x-ms-version" => serv_version, "authorization" => signed_auth }.freeze
  }
  let(:default_header_with_signed_id) {
    header = default_header.dup
    header["authorization"] = signed_auth_with_id
    header.freeze
  }

  let(:list_header) { default_header_with_signed_id }
  let(:list_result) { {"_rid"=>database_id, "Users"=>[user_record], "_count" => 1 } }

  let(:create_header) { header content_type }
  let(:create_body) { { "id" => user_name } }

  let(:user) { Azure::DocumentDB::User.new context, rest_client }

  def headers type
    header = default_header.dup
    header[type] = "application/json"
    header
  end

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(context).service_version { serv_version }
    give(Time).now { time }
    give(time).httpdate { http_date }
    give(master_token).generate("get", resource_type, database_id, http_date) { signed_auth_with_id }
    give(rest_client).get(users_url, list_header) { list_result.to_json }
  }

  it "can list the existing databases" do
    expect(user.list database_id).to eq list_result
  end
end
