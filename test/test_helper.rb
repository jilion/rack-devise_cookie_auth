require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack/devise_cookie_auth'

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rack::Lint.new(@app)
  end

  def mock_app(options = {})
    @options = options
    @app     = app_builder
  end

  def verifier(secret = nil)
    @verifier ||= ActiveSupport::MessageVerifier.new(secret || @options[:secret])
  end

  private

  def app_builder
    builder = Rack::Builder.new
    builder.use Rack::DeviseCookieAuth, @options
    builder.run(main_app)
    builder.to_app
  end

  def main_app
    lambda { |env|
      headers = { 'Content-Type' => 'text/html' }
      [200, headers, ['Hello world!']]
    }
  end

  def set_cookie!(name, value)
    set_cookie("#{name}=#{value}; expires=#{Time.now + 3600}; secure; HttpOnly", URI.parse("https://www.example.org"))
  end

end
