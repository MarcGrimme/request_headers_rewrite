# frozen_string_literal: true

require 'request_headers_rewrite/railtie' if defined?(Rails)

# Let's you modify request headers by copy, move or delete them
module RequestHeadersRewrite
  autoload :VERSION, 'request_headers_rewrite/version'
  autoload :RuleSet, 'request_headers_rewrite/ruleset'
  autoload :Middleware, 'request_headers_rewrite/middleware'

  extend self

  attr_accessor :rule_set

  def configure(&rule_block)
    @rule_set = RuleSet.new.instance_eval(&rule_block) if block_given?
  end
end
