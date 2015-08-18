require 'spec_helper'
require 'header/secure_header'

describe Azure::DocumentDB::SecureHeader do
  let(:header) { gimme(Azure::DocumentDB::Header) }
  let(:token) { gimme(Azure::DocumentDB::MasterToken) }
  let(:verb) { 'a verb' }
  let(:resource_type) { 'resource_type' }
  let(:resource_id) { 'an_id' }
  let(:time) { gimme(Time) }
  let(:http_date) { 'http_date' }
  let(:secure_auth) { 'secure_auth' }
  let(:secure_auth_with_id) { 'secure_auth_with_id' }
  let(:authorized_header) { 'authorized_header' }
  let(:authorized_header_with_id) { 'authorized_header_with_id' }
  let(:default_settings) { ['x-ms-version'] }
  let(:secure_hash) { { 'x-ms-date' => http_date, 'authorization' => secure_auth } }
  let(:secure_hash_with_id) { { 'x-ms-date' => http_date, 'authorization' => secure_auth_with_id } }

  let(:secure_header) { Azure::DocumentDB::SecureHeader.new token, resource_type }

  before(:each) {
    give(Time).now { time }
    give(time).httpdate { http_date }
    give(token).generate(verb, resource_type, '', http_date) { secure_auth }
    give(token).generate(verb, resource_type, resource_id, http_date) { secure_auth_with_id }
    give(header).generate(default_settings, secure_hash) { authorized_header }
    give(header).generate(default_settings, secure_hash_with_id) { authorized_header_with_id }
    give(Azure::DocumentDB::Header).new { header }
  }

  it 'will supply a secure auth' do
    expect(secure_header.header verb).to eq authorized_header
  end

  it 'will supply a secure auth with a supplied resource_id' do
    expect(secure_header.header verb, resource_id).to eq authorized_header_with_id
  end
end
