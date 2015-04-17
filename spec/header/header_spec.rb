require 'spec_helper'
require 'header/header'

describe Azure::DocumentDB::Header do
  let(:version) { Azure::DocumentDB::VERSION }
  let(:user_agent) { "User-Agent" }
  let(:header_sdk_defaults) { [user_agent] }
  let(:all_header_sdk_defaults) { header_sdk_defaults.concat ["x-ms-version"] }
  let(:header_optionals) { { :key => "value", :foo => "bar" } }
  let(:expected_header) { {user_agent => "rubysdk/#{version}"} }
  let(:other_default_headers) { { "x-ms-version" => "2014-08-21" } }
  let(:expected_full_default_header) { expected_header.merge other_default_headers }
  let(:expected_full_header) { expected_header.merge header_optionals }
  let(:header) { Azure::DocumentDB::Header.new }

  it "will supply requested sdk default headers" do
    expect(header.generate header_sdk_defaults).to eq expected_header
  end

  it "will supply all requested sdk default headers" do
    expect(header.generate all_header_sdk_defaults).to eq expected_full_default_header
  end

  it "will merge in supplied headers" do
    expect(header.generate header_sdk_defaults, header_optionals).to eq expected_full_header
  end
end
