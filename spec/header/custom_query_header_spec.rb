require 'spec_helper'
require 'header/custom_query_header'

describe Azure::DocumentDB::CustomQueryHeader do
  let(:cq_header) { Azure::DocumentDB::CustomQueryHeader.new }
  let(:raw_header) { { "key1" => "value1" } }
  let(:time) { gimme(Time) }
  let(:http_date) { "http_date" }
  let(:max_item_count) { "x-ms-max-item-count" }
  let(:continuation) { "x-ms-continuation" }
  let(:version) { "x-ms-version" }
  let(:session_token) { "x-ms-session-token" }
  let(:enable_scan) { "x-ms-documentdb-query-enable-scan" }
  let(:max_item_count_error) { "Max items per page must be between 1 and 1000" }
  let(:minimum_required) { raw_header.merge({ "x-ms-date" => http_date, "x-ms-documentdb-isquery" => true }) }

  before(:each) {
    give(Time).now { time }
    give(time).httpdate { http_date }
  }

  it "returns the raw header when supplied no additional headers" do
    expect(cq_header.header raw_header).to eq minimum_required
  end

  it "can set the max items to return per page" do
    count = 100
    cq_header.max_items_per_page count
    expect(cq_header.header raw_header).to eq minimum_required.merge( { max_item_count => count } )
  end

  it "will raise an error when values greater then 1000 are set for max items per page" do
    expect { cq_header.max_items_per_page 1001 }.to raise_error ArgumentError, max_item_count_error
  end

  it "will raise an error when values less than 1 are set for max items per page" do
    expect { cq_header.max_items_per_page 0 }.to raise_error ArgumentError, max_item_count_error
  end

  it "will raise an error when a non integer value is set for max items per page" do
    expect { cq_header.max_items_per_page nil }.to raise_error ArgumentError, max_item_count_error
  end

  it "can add a continuation token" do
    continuation_token = "Blarg"
    cq_header.continuation_token continuation_token
    expect(cq_header.header raw_header).to eq minimum_required.merge( { continuation => continuation_token } )
  end

  it "will raise an error when a nil token is added" do
    expect{cq_header.continuation_token nil}.to raise_error ArgumentError, "x-ms-continuation token must be supplied from previous response"
  end

  it "can add version" do
    version_value = "Blarg"
    cq_header.service_version version_value
    expect(cq_header.header raw_header).to eq minimum_required.merge( { version => version_value } )
  end

  it "can add query scan capabilities" do
    scan_enabled = true
    cq_header.enable_scan scan_enabled
    expect(cq_header.header raw_header).to eq minimum_required.merge( { enable_scan => scan_enabled } )
  end

  it "will raise an error when a non-binary option is added for enable scan" do
    scan_enabled = "true"
    expect { cq_header.enable_scan scan_enabled }.to raise_error ArgumentError, "Only binary values are allowed for enable scan"
  end

  it "can add a session token" do
    token = "Blarg"
    cq_header.session_token token
    expect(cq_header.header raw_header).to eq minimum_required.merge( { session_token => token } )
  end
end
