require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/mock'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack/cookie_auth'
require 'active_support/duration'

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rack::Lint.new(@app)
  end

  def mock_app(options = {})
    @options = options
    @app     = app_builder
  end

  def verifier(cookie_secret = nil)
    @verifier ||= ActiveSupport::MessageVerifier.new(cookie_secret || @options[:cookie_secret])
  end

  private

  def app_builder
    builder = Rack::Builder.new
    builder.use Rack::CookieAuth, @options
    builder.run(main_app)
    builder.to_app
  end

  def main_app
    lambda { |env|
      headers = { 'Content-Type' => 'text/html' }
      [200, headers, ['Hello world!']]
    }
  end

  def set_cookie!(name, value, expires_at)
    set_cookie("#{name}=#{value}; expires=#{expires_at}; secure; HttpOnly", URI.parse("https://www.example.org"))
  end

end
