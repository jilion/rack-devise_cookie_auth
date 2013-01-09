require 'rack/cookie_auth/version'
require 'active_support/message_verifier'

module Rack
  class CookieAuth
    DEFAULT_OPTIONS = {
      cookie_name: 'remember_user_token',
      user_id_key: 'current_user_id',
      redirect_to: nil,
      return_to_param_key: 'user_return_to'
    }
    def initialize(app, options = {})
      raise ArgumentError, 'Cookie secret must be set!' if options[:cookie_secret].nil?

      @app, @options = app, DEFAULT_OPTIONS.merge(options)
    end

    def call(env)
      @request = Rack::Request.new(env)

      verifier = ActiveSupport::MessageVerifier.new(@options[:cookie_secret])
      env[@options[:user_id_key]], expires_at = verifier.verify(@request.cookies[@options[:cookie_name]])

      if expires_at > Time.now
        @app.call(env)
      else
        redirect!
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect!
    end

    private

    def redirect!
      [302, { 'Content-Type' => 'text/html', 'Location' => redirect_url }, ["Redirected to #{redirect_url}!"]]
    end

    def redirect_url
      [redirect_to, return_to].compact.join('?')
    end

    def redirect_to
      if @options[:redirect_to] =~ %r{\Ahttps?://}
        @options[:redirect_to]
      else
        @request.url.sub(@request.fullpath, "/#{@options[:redirect_to]}".squeeze('/').sub(%r{/\z}, '') || '')
      end
    end

    def return_to
      if @options[:return_to_param_key]
        "#{@options[:return_to_param_key]}=#{@request.url}"
      end
    end

  end
end
