require 'spec_helper'
require 'collection/index_path'

describe Azure::DocumentDB::IndexPath do
  let(:index_type) { Azure::DocumentDB::IndexType.HASH }
  let(:path) { "A valid document path including wildcards value of ? and *." }
  let(:body) { {"Path" => path, "indexType" => index_type} }
  let(:index_path) { Azure::DocumentDB::IndexPath.new path, index_type }
  let(:root_path_body) { Azure::DocumentDB::IndexPath.new("\/", index_type).body }
  let(:ts_path_body) { Azure::DocumentDB::IndexPath.new("/\"_ts\"/?", Azure::DocumentDB::IndexType.RANGE).body }

  it "Can generate an index path" do
    expect(index_path.body).to eq body.to_json
  end

  it "Has a default root path" do
    expect(Azure::DocumentDB::IndexPath.ROOT_PATH.body).to eq root_path_body
  end

  it "Will return a default root path cannot be changed" do
    root_path = Azure::DocumentDB::IndexPath.ROOT_PATH
    expect{root_path.numeric_precision 7}.to raise_error NoMethodError
  end

  it "Has a default root path" do
    expect(Azure::DocumentDB::IndexPath.TS_PATH.body).to eq ts_path_body
  end

  it "Will return a ts path cannot be changed" do
    ts_path = Azure::DocumentDB::IndexPath.TS_PATH
    expect{ts_path.numeric_precision 7}.to raise_error NoMethodError
  end

  context "When supplied a numeric precision" do
    let(:precision) { 1 }
    let(:body) { {"Path" => path, "indexType" => index_type, "NumericPrecision": precision} }

    it "Can generate an index path" do
      index_path.numeric_precision precision
      expect(index_path.body).to eq body.to_json
    end

    context "when the precision is too large" do
      let(:precision) { 8 }

      it "will throw argument error" do
        expect{index_path.numeric_precision precision}.to raise_error(ArgumentError, "Precision of #{precision} is outside range of 1 to 7.")
      end
    end
    context "when the precision is too small" do
      let(:precision) { 0 }

      it "will throw argument error" do
        expect{index_path.numeric_precision precision}.to raise_error(ArgumentError, "Precision of #{precision} is outside range of 1 to 7.")
      end
    end
  end

  context "When supplied a string precision" do
    let(:precision) { 7 }
    let(:body) { {"Path" => path, "indexType" => index_type, "StringPrecision": precision} }

    it "Can generate an index path" do
      index_path.string_precision precision
      expect(index_path.body).to eq body.to_json
    end

    context "when the precision is too large" do
      let(:precision) { 8 }

      it "will throw argument error" do
        expect{index_path.string_precision precision}.to raise_error(ArgumentError, "Precision of #{precision} is outside range of 1 to 7.")
      end
    end
    context "when the precision is too small" do
      let(:precision) { 0 }

      it "will throw argument error" do
        expect{index_path.string_precision precision}.to raise_error(ArgumentError, "Precision of #{precision} is outside range of 1 to 7.")
      end
    end
  end

  context "When supplied a string and a numeric precision" do
    let(:numeric_precision) { 1 }
    let(:string_precision) { 7 }
    let(:body) { {"Path" => path, "indexType" => index_type, "NumericPrecision": numeric_precision, "StringPrecision": string_precision} }

    it "Can generate an index path" do
      index_path.numeric_precision numeric_precision
      index_path.string_precision string_precision
      expect(index_path.body).to eq body.to_json
    end
  end
end
