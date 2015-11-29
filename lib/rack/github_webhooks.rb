require 'rack/github_webhooks/version'
require 'openssl'
require 'json'

module Rack
  class GithubWebhooks
    class Signature
      HMAC_DIGEST = OpenSSL::Digest.new('sha1')

      def initialize(secret, hub_signature, payload_body)
        @secret = secret
        @hub_signature = hub_signature
        @signature = 'sha1=' +
                     OpenSSL::HMAC.hexdigest(HMAC_DIGEST, secret, payload_body)
      end

      def valid?
        return true unless @secret
        return false unless @hub_signature
        Rack::Utils.secure_compare(@signature, @hub_signature)
      end
    end

    def initialize(app, opts = {})
      @app = app
      @secret = opts[:secret]
    end

    def call(env)
      env['rack.input'].rewind
      signature = Signature.new(
        @secret,
        env['HTTP_X_HUB_SIGNATURE'],
        env['rack.input'].read
      )
      return [400, {}, ["Signatures didn't match!"]] unless signature.valid?
      @app.call(env)
    end
  end
end
