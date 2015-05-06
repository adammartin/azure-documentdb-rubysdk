require 'spec_helper'
require 'json'
require 'context'
require 'header/secure_header'
require 'auth/master_token'
require 'collection/collection'

describe Azure::DocumentDB::Collection do
  let(:url) { "our_url" }
  let(:resource_type) { "colls" }
  let(:database_id) { "dbs_rid" }
  let(:dbs_resource) { "dbs/#{database_id}" }
  let(:coll_url) { "#{dbs_resource}/colls" }
  let(:full_coll_url) { "#{url}/#{coll_url}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:coll_name) { "some_name" }
  let(:coll_id) { "HN49AMgSAwA=" }
  let(:coll_record) { { "id" => coll_name, "_rid" => coll_id, "_self" => coll_url, "indexingPolicy" => []} }

  let(:list_header) { "list_header" }
  let(:list_result) { { "_rid"=>database_id, "DocumentCollections"=>[coll_record]} }

  let(:create_header) { "create_header" }
  let(:create_body) { { "id" => coll_name } }

  let(:collection) { Azure::DocumentDB::Collection.new context, rest_client }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint {url}
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get", database_id) { list_header }
    give(secure_header).header("post", database_id) { create_header }
    give(rest_client).get(full_coll_url, list_header) { list_result.to_json }
    give(rest_client).post(full_coll_url, create_body.to_json, create_header) { coll_record.to_json }
  }

  it "Can list the existing collections for a database" do
    expect(collection.list database_id).to eq list_result
  end

  it "can create a new collection in a database" do
    expect(collection.create database_id, coll_name).to eq coll_record
  end
end
