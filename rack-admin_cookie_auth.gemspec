# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-admin_cookie_auth/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-admin_cookie_auth"
  gem.version       = Rack::AdminCookieAuth::VERSION
  gem.authors       = ["Rémy Coutable"]
  gem.email         = ["remy@rymai.me"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
