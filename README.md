Rack::DeviseCookieAuth [![Build Status](https://secure.travis-ci.org/jilion/rack-devise_cookie_auth.png?branch=master)](http://travis-ci.org/jilion/rack-devise_cookie_auth) [![Dependency Status](https://gemnasium.com/jilion/rack-devise_cookie_auth.png)](https://gemnasium.com/jilion/rack-devise_cookie_auth) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jilion/rack-devise_cookie_auth)
=====

Rack::DeviseCookieAuth allows to log-in from a remember-me [Devise](https://github.com/plataformatec/devise) token stored in a cookie.

It depends on Active::Support >= 2.3.2 and is tested against Ruby 1.9.2, 1.9.3, ruby-head and the latest versions of Rubinius & JRuby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-devise_cookie_auth'
```

And then execute:

```
$ bundle
```

## Basic Usage

If you don't use Bundler, be sure to require Rack::DeviseCookieAuth manually before actually using the middleware:

```ruby
 require 'rack/devise_cookie_auth'
 use Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET'
```

To use Rack::DeviseCookieAuth in your Rails application, add the following line to your application config file (`config/application.rb` or `config/environments/production.rb`) for Rails 3, `config/environment.rb` for Rails 2):

```ruby
config.use Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET'

# or if you're using Rack::Cache, be sure to insert Rack::DeviseCookieAuth before
config.middleware.insert_before Rack::Cache, Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET'
```

Please note that the `:secret` option is mandatory and can normally be found in the 'config/initializers/secret_token.rb' file of your Rails app.

## Options

### Resource name

By default, the middleware will look for the user resource cookie named "remember_user_token" but if want to use authenticate againts another resource name you can set it with the `:resource` option:

```ruby
config.middleware.use Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET', resource: 'admin'
```

### Redirection URL

By default, the middleware will redirect to the root path of the current domain but you can customize the redirection path with the `:redirect_to` option:

```ruby
# It can be a path...
config.middleware.use Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET', redirect_to: '/login'

# ... or a full URL
config.middleware.use Rack::DeviseCookieAuth, secret: 'YOUR_SESSION_SECRET', redirect_to: 'https://yourdomain.com/login'
```

Development
-----------

* Documentation hosted at [RubyDoc](http://rubydoc.info/github/jilion/rack-devise_cookie_auth/master/frames).
* Source hosted at [GitHub](https://github.com/jilion/rack-devise_cookie_auth).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested.
* Update the [README](https://github.com/jilion/rack-devise_cookie_auth/blob/master/README.md).
* Update the [CHANGELOG](https://github.com/jilion/rack-devise_cookie_auth/blob/master/CHANGELOG.md) for noteworthy changes.
* Please **do not change** the version number.

### Authors

* [Rémy Coutable](https://github.com/rymai) ([@rymai](http://twitter.com/rymai), [rymai.me](http://rymai.me))
* [Thibaud Guillaume-Gentil](https://github.com/thibaudgg) ([@thibaudgg](http://twitter.com/thibaudgg), [thibaud.me](http://thibaud.me))

### Contributors

[https://github.com/jilion/rack-devise_cookie_auth/graphs/contributors](https://github.com/jilion/rack-devise_cookie_auth/contributors)
