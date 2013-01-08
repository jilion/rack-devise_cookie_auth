Rack::CookieAuth [![Build Status](https://secure.travis-ci.org/jilion/rack-cookie_auth.png?branch=master)](http://travis-ci.org/jilion/rack-cookie_auth) [![Dependency Status](https://gemnasium.com/jilion/rack-cookie_auth.png)](https://gemnasium.com/jilion/rack-cookie_auth) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jilion/rack-cookie_auth)
=====

Rack::CookieAuth allows to log-in from a remember-me token stored in a cookie.

It depends on Active::Support >= 2.3.2 and is tested against Ruby 1.9.2, 1.9.3, ruby-head and the latest versions of Rubinius & JRuby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-cookie_auth'
```

And then execute:

```
$ bundle
```

## Basic Usage

If you don't use Bundler, be sure to require Rack::CookieAuth manually before actually using the middleware:

```ruby
 require 'rack/cookie_auth'
 use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET'
```

To use Rack::CookieAuth in your Rails application, add the following line to your application config file (`config/application.rb` or `config/environments/production.rb`) for Rails 3, `config/environment.rb` for Rails 2):

```ruby
config.use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET'

# or if you're using Rack::Cache, be sure to insert Rack::CookieAuth before
config.middleware.insert_before Rack::Cache, Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET'
```

Please note that the `:cookie_secret` option is mandatory!

## Options

### Cookie name

By default, the middleware will look for a cookie named "remember_user_token" but if your cookie is named otherwise, for instance "remember_admin_token", you can set it with the `:cookie_name` option:

```ruby
config.middleware.use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET', cookie_name: 'remember_admin_token'
```

### Redirection URL

By default, the middleware will redirect to the root path of the current domain but you can customize the redirection path with the `:redirect_to` option:

```ruby
# It can be a path...
config.middleware.use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET', redirect_to: '/login'

# ... or a full URL
config.middleware.use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET', redirect_to: 'https://yourdomain.com/login'
```

### Key in the Rack env for the current logged-in user ID

By default, the middleware will store the ID of the user retrieved from the cookie in `env['user_id_key']` but if you want to use another key, for instance "admin_id_key", you can set it with the `:user_id_key` option:

```ruby
config.middleware.use Rack::CookieAuth, cookie_secret: 'YOUR_SESSION_SECRET', user_id_key: 'admin_id_key'
```

Development
-----------

* Documentation hosted at [RubyDoc](http://rubydoc.info/github/jilion/rack-cookie_auth/master/frames).
* Source hosted at [GitHub](https://github.com/jilion/rack-cookie_auth).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested.
* Update the [README](https://github.com/jilion/rack-cookie_auth/blob/master/README.md).
* Update the [CHANGELOG](https://github.com/jilion/rack-cookie_auth/blob/master/CHANGELOG.md) for noteworthy changes.
* Please **do not change** the version number.

### Author

[Rémy Coutable](https://github.com/rymai) ([@rymai](http://twitter.com/rymai), [rymai.me](http://rymai.me))

### Contributors

[https://github.com/jilion/rack-cookie_auth/graphs/contributors](https://github.com/jilion/rack-cookie_auth/contributors)
