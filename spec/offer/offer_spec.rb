require 'spec_helper'
require 'offer/offer'
require 'query/query'

describe Azure::DocumentDB::Offer do
  let(:offer_type) { "S1" }
  let(:offer_name) { "OFFER_NAME" }
  let(:new_offer_name) { "NEW_OFFER_NAME" }
  let(:offer_id) { "OFFER_rID" }
  let(:offer_resource_id) { "OFFER_RESOURCE_ID" }
  let(:resource_type) { Azure::DocumentDB::ResourceType.OFFER }
  let(:url) { "our_url" }
  let(:offers_url) { "#{url}/#{resource_type}" }
  let(:target_url) { "#{offers_url}/#{offer_id}" }
  let(:rest_client) { gimme }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:query) { gimme(Azure::DocumentDB::Query) }
  let(:get_header) { "get_header" }
  let(:get_offer_header) { "get_offer_header" }
  let(:replace_header) { "replace_header" }
  let(:offer_record) { { "offerType" => offer_type, "resource" => "dbs/pLJdAA==/colls/#{offer_resource_id}/", "offerResourceId" => offer_resource_id, "id" => offer_name, "_rid" => offer_id } }
  let(:new_offer_record) { offer_record.merge({"id"=>new_offer_name}) }
  let(:offer) { Azure::DocumentDB::Offer.new context, rest_client }

  let(:list_result) { { "_rid" => "", "Offers" => [offer_record], "_count" => 1 } }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::Query).new(context, rest_client, resource_type, '', offers_url) { query }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get") { get_header }
    give(secure_header).header("get", offer_id) { get_offer_header }
    give(secure_header).header("put", offer_id) { replace_header }
    give(rest_client).get(offers_url, get_header) { list_result.to_json }
    give(rest_client).get(target_url, get_offer_header) { offer_record.to_json }
    give(rest_client).put(target_url, new_offer_record.to_json, replace_header) { new_offer_record.to_json }
  }

  it "can list the existing offerings" do
    expect(offer.list).to eq list_result
  end

  it "can get an offer" do
    expect(offer.get offer_id).to eq offer_record
  end

  it "can replace an offer" do
    expect(offer.replace offer_id, new_offer_record.to_json).to eq new_offer_record
  end

  it "can get the uri of the offer resource" do
    expect(offer.uri).to eq offers_url
  end

  it "can get a query object" do
    expect(offer.query).to eq query
  end
end
