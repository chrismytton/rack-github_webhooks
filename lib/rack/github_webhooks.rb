require 'rack/github_webhooks/version'
require 'openssl'
require 'json'

module Rack
  class GithubWebhooks
    HMAC_DIGEST = OpenSSL::Digest.new('sha1')

    attr_reader :app
    attr_reader :secret
    attr_reader :request

    def initialize(app, opts = {})
      @app = app
      @secret = opts[:secret]
    end

    def call(env)
      @request = Rack::Request.new(env)
      return [400, {}, ["Signatures didn't match!"]] unless signature_valid?
      app.call(env)
    end

    private

    # Taken from https://developer.github.com/webhooks/securing/
    def signature_valid?
      return true unless secret
      return false unless request.env['HTTP_X_HUB_SIGNATURE']
      Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end

    def signature
      "sha1=#{OpenSSL::HMAC.hexdigest(HMAC_DIGEST, secret, payload_body)}"
    end

    def payload_body
      @payload_body ||= begin
        request.body.rewind
        request.body.read
      end
    end
  end
end
