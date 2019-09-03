# frozen_string_literal: true

module RequestHeadersRewrite
  class Middleware # :nodoc:
    def initialize(app, &rule_block)
      @app = app
      if block_given?
        @rule_set = RuleSet.new.instance_eval(&rule_block)
      elsif RequestHeadersRewrite.rule_set
        @rule_set = RequestHeadersRewrite.rule_set
      end
    end

    # will be called from the middleware for each request and rewrite the
    # header according to the ruleset if a ruleset is given
    def call(env)
      @rule_set&.apply!(env)
      @app.call(env)
    end
  end
end
