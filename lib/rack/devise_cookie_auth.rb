require 'rack/devise_cookie_auth/version'
require 'active_support/message_verifier'

module Rack
  class DeviseCookieAuth
    DEFAULT_OPTIONS = {
      resource: 'user',
      redirect_to: nil
    }
    def initialize(app, options = {})
      raise ArgumentError, 'Cookie secret must be set!' if options[:secret].nil?

      @app, @options = app, DEFAULT_OPTIONS.merge(options)
    end

    def call(env)
      @request = Rack::Request.new(env)

      verifier = ActiveSupport::MessageVerifier.new(@options[:secret])
      resource_ids, remember_key = verifier.verify(@request.cookies[cookie_name])
      env["current_#{resource}_id"] = resource_ids.first

      @app.call(env)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect!
    end

    private

    def redirect!
      [302, { 'Content-Type' => 'text/html', 'Location' => redirect_url }, ["Redirected to #{redirect_url}!"]]
    end

    def resource
      @options[:resource].to_s
    end

    def cookie_name
      "remember_#{resource}_token"
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
      "#{resource}_return_to=#{@request.url}"
    end

  end
end
