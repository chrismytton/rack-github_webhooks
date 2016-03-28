require 'test_helper'

class RackGithubWebhooksTest < Minitest::Test
  HMAC_DIGEST = OpenSSL::Digest.new('sha1')

  include Rack::Test::Methods

  def body_signature(body)
    'sha1=' + OpenSSL::HMAC.hexdigest(
      HMAC_DIGEST,
      's3cret',
      body
    )
  end

  def app
    @app ||= Rack::Builder.new do
      use Rack::GithubWebhooks, secret: 's3cret'
      run ->(env) { [200, {}, ['ok']] }
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Rack::GithubWebhooks::VERSION
  end

  def test_invalid_signature
    post '/',
      '{}',
      'HTTP_X_HUB_SIGNATURE' => 'sha1=invalid'
    assert_equal 400, last_response.status
    assert_equal "Signatures didn't match!", last_response.body
  end

  def test_valid_signature
    body = '{}'
    post '/', body, 'HTTP_X_HUB_SIGNATURE' => body_signature(body)
    assert_equal 200, last_response.status
    assert_equal 'ok', last_response.body
  end

  def test_no_signature
    post '/', '{}'
    assert_equal 400, last_response.status
    assert_equal "Signatures didn't match!", last_response.body
  end

  def test_post_body
    body = '{content: "text"}'
    post '/', body, 'HTTP_X_HUB_SIGNATURE' => body_signature(body)
    assert_equal body, last_request.body.read
  end
end
