require 'spec_helper'
require 'auth/hmac_encoder'

describe Azure::HMACEncoder do
  let(:master_key) { "blah" }
  let(:message) { "get\ncolls\n\nTue, 14 Apr 2015 13:34:22 GMT\n\n" }
  let(:auth_key) { "IYlLuyZtVLx5ANkGMAxviDHgC/DJJXSj1gUGLvN0oM8=" }

  it "should encode the message using the key" do
    expect(Azure::HMACEncoder.new.encode master_key, message).to eq auth_key
  end
end
