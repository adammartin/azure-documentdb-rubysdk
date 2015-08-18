require 'spec_helper'
require 'header/header'
require 'version/version'

describe Azure::DocumentDB::Header do
  let(:header_sdk_defaults) { ['x-ms-version'] }
  let(:header_optionals) { { :key => 'value', :foo => 'bar' } }
  let(:expected_header) { { 'x-ms-version' => Azure::DocumentDB::SERVICE_VERSION } }
  let(:expected_full_header) { expected_header.merge header_optionals }
  let(:header) { Azure::DocumentDB::Header.new }

  it 'will supply requested sdk default headers' do
    expect(header.generate header_sdk_defaults).to eq expected_header
  end

  it 'will merge in supplied headers' do
    expect(header.generate header_sdk_defaults, header_optionals).to eq expected_full_header
  end
end
