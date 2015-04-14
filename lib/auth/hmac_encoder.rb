require 'openssl'
require 'base64'

module Azure
  module DocumentDB
    class HMACEncoder
      def encode master_key, message
        key = Base64.urlsafe_decode64 master_key
        hmac = OpenSSL::HMAC.digest 'sha256', key, message.downcase
        Base64.encode64(hmac).strip
      end
    end
  end
end
