require 'spec_helper'
require 'auth/master_token'

describe Azure::MasterToken do
  let(:verb) { "REST_VERB" }
  let(:resource_id) { "SOME_ID" }
  let(:resource_type) { "DOCUMENTDB_RESOURCE" }
  let(:date) { "DATE_IN_RFC7321_FORMAT" }
  let(:master_key) { "MASTER_KEY" }
  let(:encoder) { gimme(Azure::HMACEncoder) }
  let(:unencoded_signature) { "#{verb}\n#{resource_type}\n#{resource_id}\n#{date}\n\n" }
  let(:encoded_signature) { "ENCODED MESSAGE" }
  let(:uri_encoded_auth) { "ENCODED%20MESSAGE" }
  let(:master_auth_token) { "type=master&ver=1.0&sig=#{uri_encoded_auth}" }
  let(:master_token) { Azure::MasterToken.new verb, resource_type, resource_id, master_key }

  before(:each) {
    give(Azure::HMACEncoder).new { encoder }
    give(encoder).encode(master_key, unencoded_signature) { encoded_signature }
  }

  it "Generates the encoded string" do
    expect(master_token.generate date).to eq master_auth_token
  end
end
