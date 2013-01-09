# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/devise_cookie_auth/version'

Gem::Specification.new do |gem|
  gem.name          = 'rack-devise_cookie_auth'
  gem.version       = Rack::DeviseCookieAuth::VERSION
  gem.authors       = ['Rémy Coutable', 'Thibaud Guillaume-Gentil']
  gem.email         = ['remy@jilion.com', 'thibaud@jilion.com']
  gem.homepage      = 'https://github.com/jilion/rack-devise_cookie_auth'
  gem.description   = %q{Rack middleware to log in from a "remember me" Devise cookie.}
  gem.summary       = %q{Rack middleware to log admin in from a "remember me" Devise cookie.}

  gem.files        = Dir.glob("{lib}/**/*") + %w[CHANGELOG.md LICENSE.md README.md]
  gem.require_path = 'lib'

  gem.add_dependency 'rack',          '>= 1.0'
  gem.add_dependency 'activesupport', '>= 2.3.2'

  gem.add_development_dependency 'bundler',   '~> 1.0'
  gem.add_development_dependency 'test-unit', '~> 2.5'
  gem.add_development_dependency 'rack-test', '~> 0.6'
  gem.add_development_dependency 'shoulda',   '~> 3.3'
end
