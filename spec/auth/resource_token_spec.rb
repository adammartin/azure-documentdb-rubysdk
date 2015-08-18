require 'spec_helper'
require 'auth/resource_token'

describe Azure::DocumentDB::ResourceToken do
  let(:raw_token) { 'raw token' }
  let(:encoded_token) { 'raw%20token' }
  let(:permission_record) { { 'id' => 'unimportant', 'permissionMode' => 'ALL', 'resource' => 'dbs_resource', '_rid' => 'dbs_rid', '_token' => raw_token } }
  let(:time) { gimme(Time) }
  let(:http_date) { 'http_date' }
  let(:header) { gimme(Azure::DocumentDB::Header) }
  let(:default_settings) { ['User-Agent', 'x-ms-version'] }
  let(:secure_hash) { { 'x-ms-date' => http_date, 'authorization' => encoded_token } }
  let(:authorized_header) { 'authorized_header' }

  let(:resource_token) { Azure::DocumentDB::ResourceToken.new permission_record }

  before(:each) {
    give(Time).now { time }
    give(time).httpdate { http_date }
    give(header).generate(default_settings, secure_hash) { authorized_header }
    give(Azure::DocumentDB::Header).new { header }
  }

  it 'generates the encoded string' do
    expect(resource_token.encode_header).to eq authorized_header
  end
end
