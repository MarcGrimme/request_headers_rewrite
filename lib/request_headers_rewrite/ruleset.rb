# frozen_string_literal: true

require 'request_headers_rewrite/rule'

module RequestHeadersRewrite
  class RuleSet # :nodoc:
    attr_reader :rules
    def initialize
      @rules = []
    end

    # will apply all rules in ruleset and change the environment
    def apply!(env)
      @rules.each do |rule|
        rule.apply!(env)
      end
    end

    def copy(*args)
      add_rule 'copy', *args
      self
    end

    def move(*args)
      add_rule 'move', *args
      self
    end

    private

    def add_rule(rule_type, *args)
      @rules << Object.const_get('RequestHeadersRewrite::' +
                                 rule_type.capitalize +
                                 'Rule' || rule_type.capitalize + 'Rule')
                      .new(*args)
    end
  end
end
