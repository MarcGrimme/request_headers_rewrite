# frozen_string_literal: true

module RequestHeadersRewrite
  class Rule # :nodoc:
    attr_reader :from, :to
    def initialize(from, whereto, options = {})
      @from = from
      @to = whereto
      @options = options
    end

    def eql?(other)
      other.from == @from && other.to == @to
    end

    protected

    def header_from(env)
      env_for_header(@from, env)
    end

    def header_to(env)
      env_for_header(@to, env)
    end

    def env_for_header(value, env)
      env[header_attr(value)]
    end

    def header_attr(attr)
      'HTTP_' + attr.upcase.tr('-', '_')
    end

    def overwrite?
      @options[:overwrite] == true || @options['overwrite'] == true
    end

    def append?
      @options[:append] == true || @options['append'] == true
    end
  end

  class CopyRule < Rule # :nodoc:
    def apply!(env)
      from = header_from(env)
      to = header_to(env)
      env[header_attr(@to)] = if append?
                                to_sep(to) + (from || '')
                              elsif overwrite?
                                from
                              else
                                from_sep(from, to) + (to || '')
                              end
    end

    private

    def from_sep(from, whereto)
      if from && whereto
        from + ','
      else
        from
      end
    end

    def to_sep(whereto)
      whereto + ','
    end
  end

  class MoveRule < CopyRule # :nodoc:
    def apply!(env)
      super(env)
      env.delete(header_attr(@from))
    end
  end
end
