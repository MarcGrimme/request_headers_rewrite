# RequestHeaderRewrite [![build status](https://travis-ci.org/MarcGrimme/request_headers_rewrite.png?branch=master)](https://travis-ci.org/MarcGrimme/request_headers_rewrite) [![Code Climate](https://codeclimate.com/github/MarcGrimme/request_headers_rewrite.png)](https://codeclimate.com/github/MarcGrimme/request_headers_rewrite)

## WORDS OF WARNING - PLEASE READ BEFORE YOU GO FURTHER

This middleware seems not to be one of my best ideas. After finishing it I'm convinced that header rewriting should not be
something done in a rack/rails middleware as this stack is least efficient for this purpose. So please only use the middleware
if either you have no problem with performance impact - this middleware will fiddle with your request header for each request -
or you do it for development purposes. A third option might be that you do not have a reverse proxy (like apache or nginx) in
front of the rails app that supports header changes.

For all other options please fail back to the follwing modules:
* Apache: [mod_header](https://httpd.apache.org/docs/current/mod/mod_headers.html)
* NGINX: [headers_management](https://www.nginx.com/resources/wiki/start/topics/examples/headers_management)

## What is it about
Some times I can be handy to be able to rewrite headers in the request. This middleware is an approach to tackle that problem.
Currently it only allows to rewrite headers so that they can be replaced like as follows.

## Rails 3 or higher

```
# config/application.rb
config.middleware.insert_before(Rack::Lock, Rack::RequestHeadersRewrite) do
  copy 'TRUE-CLIENT-IP', 'X-FORWARD-FOR'
end
```

Which will automatically copy the header from TRUE-CLIENT-IP to X-FORWARD-FOR header.

If you want to move the header (which means the source is removed from the request) go as follows:

```
# config/application.rb
config.middleware.insert_before(Rack::Lock, Rack::RequestHeadersRewrite) do
  move 'TRUE-CLIENT-IP', 'X-FORWARD-FOR'
end
```

Delete is also possible as follows:

```
# config/application.rb
config.middleware.insert_before(Rack::Lock, Rack::RequestHeadersRewrite) do
  delete 'TRUE-CLIENT-IP'
end
```

## Installation

### Rails

So how does it work with Rails.

Add this line to your application's Gemfile:

``
gem 'request_headers_rewrite'
``

And then execute:

``
$ bundle
``
    
Or install it yourself as:
 
``
$ gem install request_headers_rewrite
``

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/marcgrimme/request_headers_rewrite/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
