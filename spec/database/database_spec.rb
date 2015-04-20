require 'spec_helper'
require 'database/database'

describe Azure::DocumentDB::Database do
  let(:url) { "our_url" }
  let(:resource_type) { "dbs" }
  let(:dbs_url) { "#{url}/#{resource_type}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme } # We will inject module RestClient for testability
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:time) { gimme(Time) }
  let(:http_date) { "http_date" }
  let(:signed_auth) { "signed_auth" }
  let(:signed_auth_with_id) { "signed_auth_with_id" }
  let(:serv_version) { "2014-08-21" }
  let(:accept) { "accept" }
  let(:content_type) { "Content-Type" }
  let(:client) { "rubysdk/0.0.1" }
  let(:database_name) { "new_database" }
  let(:database_id) { "0EWFAA==" }
  let(:database1) { {"id" => database_name, "_rid" => database_id, "_ts" => 1408176196, "_self" => "dbs\/0EwFAA==\/", "_etag" => "00001c00-0000-0000-0000-53ef10440000", "_colls" => "colls\/", "_users" => "users\/"} }
  let(:default_header) {
    {"User-Agent" => client, "x-ms-date" => http_date, "x-ms-version" => serv_version, "authorization" => signed_auth }.freeze
  }
  let(:default_header_with_signed_id) {
    header = default_header.dup
    header["authorization"] = signed_auth_with_id
    header.freeze
  }

  let(:list_header) { default_header }
  let(:list_result) { {"_rid"=>"", "Databases" => [database1], "_count" => 1 } }

  let(:create_header) { default_header }
  let(:create_body) { { "id" => database_name } }
  let(:create_response) { database1 }

  let(:delete_header) { default_header_with_signed_id }
  let(:delete_url) { "#{dbs_url}/#{database_id}" }

  let(:get_header) { default_header_with_signed_id }
  let(:get_response) { database1 }

  let(:database) { Azure::DocumentDB::Database.new context, rest_client }

  def headers type
    header = default_header.dup
    header
  end

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(context).service_version { serv_version }
    give(Time).now { time }
    give(time).httpdate { http_date }
    give(master_token).generate("get", resource_type, "", http_date) { signed_auth }
    give(master_token).generate("get", resource_type, database_id, http_date) { signed_auth_with_id }
    give(master_token).generate("post", resource_type, "", http_date) { signed_auth }
    give(master_token).generate("delete", resource_type, database_id, http_date) { signed_auth_with_id }
    give(rest_client).get(dbs_url, list_header) { list_result.to_json }
    give(rest_client).post(dbs_url, create_body.to_json, create_header) { create_response.to_json }
    give(rest_client).get("#{dbs_url}/#{database_id}", get_header) { get_response.to_json }
  }

  it "can list the existing databases" do
    expect(database.list).to eq list_result
  end

  it "can create a new database" do
    expect(database.create database_name).to eq create_response
  end

  it "can delete a supplied database" do
    database.delete database_id
    verify(rest_client).delete delete_url, delete_header
  end

  it "can get a supplied database" do
    expect(database.get database_id).to eq get_response
  end
end
