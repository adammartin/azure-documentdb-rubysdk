require 'spec_helper'
require 'database'

describe Azure::DocumentDB::Database do
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:url) { "our_url" }
  let(:database1) { {"id" => "ProductDB", "_rid" => "0EwFAA==" , "_ts" => 1408176196, "_self" => "dbs\/0EwFAA==\/", "_etag" => "00001c00-0000-0000-0000-53ef10440000", "_colls" => "colls\/", "_users" => "users\/"} }
  let(:list_result) { {"_rid"=>"", "Databases" => [database1], "_count" => 1 } }
  let(:rest_client) { gimme } # We will inject module RestClient for testability
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:time) { gimme(Time) }
  let(:http_date) { "http_date" }
  let(:signed_auth) { "signed_auth" }
  let(:serv_version) { "2014-08-21" }
  let(:resource_type) { "dbs" }
  let(:header) { { "accept" => "application/json", "x-ms-version" => serv_version, "x-ms-date" => http_date, "authorization" => signed_auth } }
  let(:database) { Azure::DocumentDB::Database.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(context).service_version { serv_version }
    give(Time).now { time }
    give(time).httpdate { http_date }
    give(master_token).generate("get", resource_type, "", http_date) {signed_auth}
    give(rest_client).get("#{url}/#{resource_type}", header){ list_result.to_json }
  }

  it "Can list the existing databases" do
    expect(database.list).to eq list_result
  end
end
