# frozen_string_literal: true

# Notice there is a .rspec file in the root folder. It defines rspec arguments

# Ruby 1.9 uses simplecov. The ENV['COVERAGE'] is set when rake coverage
# is run in ruby 1.9
if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov_small_badge'

  SimpleCov.start do
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCovSmallBadge::Formatter
      ]
    )
  end

  SimpleCov.minimum_coverage 100
end

require 'rubygems'
# Loads bundler setup tasks. Now if I run spec without installing gems then it
# would say gem not installed and do bundle install instead of ugly load error
# on require.
require 'bundler/setup'

# This will require me all the gems automatically for the groups. If I do only
# .setup then I will have to require gems manually. Note that you have still
# have to require some gems if they are part of bigger gem like ActiveRecord
# which is part of Rails. You can say :require => false in gemfile to always
# use explicit requiring
Bundler.require(:default, :test)

Dir[File.join('./spec/support/**/*.rb')].each { |f| require f }

# Set Rails environment as test
ENV['RAILS_ENV'] = 'test'

require 'request_headers_rewrite'
require 'rack/mock'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
