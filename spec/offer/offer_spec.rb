require 'spec_helper'
require 'json'
require 'offer/offer'

describe Azure::DocumentDB::Offer do
  let(:offer_type) { "S1" }
  let(:offer_name) { "OFFER_NAME" }
  let(:offer_id) { "OFFER_rID" }
  let(:offer_resource_id) { "OFFER_RESOURCE_ID" }
  let(:resource_type) { "offers" }
  let(:url) { "our_url" }
  let(:offers_url) { "#{url}/#{resource_type}" }
  let(:rest_client) { gimme }
  let(:context) { gimme(Azure::DocumentDB::Context) }
  let(:master_token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:secure_header) { gimme(Azure::DocumentDB::SecureHeader) }
  let(:get_header) { "get_header" }
  let(:offer_record) { { "offerType" => offer_type, "resource" => "dbs/pLJdAA==/colls/#{offer_resource_id}/", "offerResourceId" => offer_resource_id, "id" => offer_name, "_rid" => offer_id
    } }
  let(:offer) { Azure::DocumentDB::Offer.new context, rest_client }

  let(:list_result) { { "_rid" => "", "Offers" => [offer_record], "_count" => 1 } }

  before(:each) {
    give(context).master_token { master_token }
    give(context).endpoint { url }
    give(Azure::DocumentDB::SecureHeader).new(master_token, resource_type) { secure_header }
    give(secure_header).header("get") { get_header }
    give(rest_client).get(offers_url, get_header) { list_result.to_json }
  }

  it "can list the existing offerings" do
    expect(offer.list).to eq list_result
  end
end
