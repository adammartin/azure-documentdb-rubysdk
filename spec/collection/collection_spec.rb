require 'spec_helper'
require 'context'
require 'header/secure_header'
require 'auth/master_token'
require 'auth/resource_token'
require 'collection/collection'
require 'collection/index_policy'
require 'document/document'

describe Azure::DocumentDB::Collection do
  let(:url) { "our_url" }
  let(:resource_type) { "colls" }
  let(:database_id) { "dbs_rid" }
  let(:dbs_resource) { "dbs/#{database_id}" }
  let(:coll_url) { "#{dbs_resource}/colls" }
  let(:full_coll_url) { "#{url}/#{coll_url}" }
  let(:target_coll_url) { "#{full_coll_url}/#{coll_id}" }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:rest_client) { gimme }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:document) { gimme(Azure::DocumentDB::Document) }
  let(:coll_name) { "some_name" }
  let(:coll_id) { "HN49AMgSAwA=" }
  let(:policy_body) { "policy_body" }
  let(:coll_record) { { "id" => coll_name, "_rid" => coll_id, "_self" => coll_url, "indexingPolicy" => policy_body } }

  let(:list_result) { { "_rid"=>database_id, "DocumentCollections"=>[coll_record]} }

  let(:create_body) { { "id" => coll_name } }

  let(:collection) { Azure::DocumentDB::Collection.new context, rest_client, database_id }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
  }

  context "When using a master token," do
    let(:list_header) { "list_header" }
    let(:create_header) { "create_header" }
    let(:delete_header) { "delete_header" }
    let(:get_coll_header) { "get_header" }

    before(:each) {
      give(secure_header).header("get", database_id) { list_header }
      give(secure_header).header("post", database_id) { create_header }
      give(secure_header).header("get", coll_id) { get_coll_header }
      give(secure_header).header("delete", coll_id) { delete_header }
      give(rest_client).get(full_coll_url, list_header) { list_result.to_json }
      give(rest_client).post(full_coll_url, create_body.to_json, create_header) { coll_record.to_json }
      give(rest_client).get(target_coll_url, get_coll_header) { coll_record.to_json }
      give(Azure::DocumentDB::Document).new(context, rest_client, database_id, coll_id) { document }
    }

    it "can list the existing collections for a database" do
      expect(collection.list).to eq list_result
    end

    it "can create a new collection in a database" do
      expect(collection.create coll_name).to eq coll_record
    end

    it "can give the uri of the resource" do
      expect(collection.uri).to eq full_coll_url
    end

    it "can create a document object using a collection_name" do
      expect(collection.document_for_name coll_name).to eq document
    end

    it "throws an ArgumentError when supplied a resource name of a collection that does not exist when trying to create a document" do
      expect{collection.document_for_name "does_not_exist"}.to raise_error ArgumentError, "Collection for supplied name must exist"
    end

    context "When a custom policy is used" do
      let(:policy) { gimme(Azure::DocumentDB::IndexPolicy) }
      let(:create_body) { { "id" => coll_name, "IndexPolicy" => policy_body } }

      before(:each) {
        give(policy).body { policy_body }
      }

      it "can create a new collection in a database" do
        expect(collection.create coll_name, policy).to eq coll_record
      end
    end

    it "can get a collection" do
      expect(collection.get coll_id).to eq coll_record
    end

    it "can delete a collection" do
      collection.delete coll_id
      verify(rest_client).delete target_coll_url, delete_header
    end
  end

  context "When supplied a resource token" do
    let(:resource_token) { gimme(Azure::DocumentDB::ResourceToken) }
    let(:resource_header) { "resource_header" }

    before(:each) {
      give(resource_token).encode_header { resource_header }
      give(rest_client).get(full_coll_url, resource_header) { list_result.to_json }
      give(rest_client).get(target_coll_url, resource_header) { coll_record.to_json }
    }

    it "Can list the existing collections for a database associated" do
      expect(collection.list resource_token).to eq list_result
    end

    it "can get a collection" do
      expect(collection.get coll_id, resource_token).to eq coll_record
    end

    it "can delete a collection" do
      collection.delete coll_id, resource_token
      verify(rest_client).delete target_coll_url, resource_header
    end
  end
end
