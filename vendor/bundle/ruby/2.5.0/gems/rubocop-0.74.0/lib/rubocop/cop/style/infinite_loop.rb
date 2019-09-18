# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Use `Kernel#loop` for infinite loops.
      #
      # @example
      #   # bad
      #   while true
      #     work
      #   end
      #
      #   # good
      #   loop do
      #     work
      #   end
      class InfiniteLoop < Cop
        LEADING_SPACE = /\A(\s*)/.freeze

        MSG = 'Use `Kernel#loop` for infinite loops.'

        def join_force?(force_class)
          force_class == VariableForce
        end

        def after_leaving_scope(scope, _variable_table)
          @variables ||= []
          @variables.concat(scope.variables.values)
        end

        def on_while(node)
          while_or_until(node) if node.condition.truthy_literal?
        end

        def on_until(node)
          while_or_until(node) if node.condition.falsey_literal?
        end

        alias on_while_post on_while
        alias on_until_post on_until

        def autocorrect(node)
          if node.while_post_type? || node.until_post_type?
            replace_begin_end_with_modifier(node)
          elsif node.modifier_form?
            replace_source(node.source_range, modifier_replacement(node))
          else
            replace_source(non_modifier_range(node), 'loop do')
          end
        end

        private

        def while_or_until(node)
          range = node.source_range
          # Not every `while true` and `until false` can be turned into a
          # `loop do` without further modification. The reason is that a
          # variable that's introduced inside a while/until loop is in scope
          # outside of that loop too, but a variable that's assigned for the
          # first time inside a block can not be accessed after the block. In
          # those more complicated cases we don't report an offense.
          return if @variables.any? do |var|
            assigned_inside_loop?(var, range) &&
            !assigned_before_loop?(var, range) &&
            referenced_after_loop?(var, range)
          end

          add_offense(node, location: :keyword)
        end

        def assigned_inside_loop?(var, range)
          var.assignments.any? { |a| range.contains?(a.node.source_range) }
        end

        def assigned_before_loop?(var, range)
          b = range.begin_pos
          var.assignments.any? { |a| a.node.source_range.end_pos < b }
        end

        def referenced_after_loop?(var, range)
          e = range.end_pos
          var.references.any? { |r| r.node.source_range.begin_pos > e }
        end

        def replace_begin_end_with_modifier(node)
          lambda do |corrector|
            corrector.replace(node.body.loc.begin, 'loop do')
            corrector.remove(node.body.loc.end.end.join(node.source_range.end))
          end
        end

        def replace_source(range, replacement)
          lambda do |corrector|
            corrector.replace(range, replacement)
          end
        end

        def modifier_replacement(node)
          if node.single_line?
            'loop { ' + node.body.source + ' }'
          else
            indentation = node.body.loc.expression.source_line[LEADING_SPACE]

            ['loop do', node.body.source.gsub(/^/, configured_indent),
             'end'].join("\n#{indentation}")
          end
        end

        def non_modifier_range(node)
          start_range = node.loc.keyword.begin
          end_range = if node.do?
                        node.loc.begin.end
                      else
                        node.condition.source_range.end
                      end

          start_range.join(end_range)
        end

        def configured_indent
          ' ' * config.for_cop('IndentationWidth')['Width']
        end
      end
    end
  end
end