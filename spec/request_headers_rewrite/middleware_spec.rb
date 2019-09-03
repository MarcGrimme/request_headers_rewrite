# frozen_string_literal: true

require 'spec_helper'

module RequestHeadersRewrite
  describe Middleware do
    let(:app) { MockRackApp.new }

    let(:env) do
      Rack::MockRequest.env_for('/some/path',
                                'HTTP_X_FORWARDED_FOR_1' => '1234',
                                'HTTP_X_FORWARDED_FOR_2' => '123',
                                'HTTP_X_FORWARDED_FOR' => '12',
                                'CONTENT_TYPE' => 'text/plain')
    end

    context 'initialize by ruleset' do
      subject do
        RequestHeadersRewrite.configure do |rule_set|
          rule_set.copy('X-Forwarded-For-2', 'X-Forwarded-For')
        end
        described_class.new(app)
      end

      before { subject.call(env) }

      it 'X-Forwared-For-2 => X-Forwared-For' do
        expect(env).to include(
          'HTTP_X_FORWARDED_FOR_1' => '1234',
          'HTTP_X_FORWARDED_FOR_2' => '123',
          'HTTP_X_FORWARDED_FOR' => '123,12',
          'CONTENT_TYPE' => 'text/plain'
        )
      end
    end

    context 'one copy rule' do
      subject do
        described_class.new(app) do
          copy 'X-Forwarded-For-2', 'X-Forwarded-For'
        end
      end

      before { subject.call(env) }

      it 'X-Forwared-For-2 => X-Forwared-For' do
        expect(env).to include(
          'HTTP_X_FORWARDED_FOR_1' => '1234',
          'HTTP_X_FORWARDED_FOR_2' => '123',
          'HTTP_X_FORWARDED_FOR' => '123,12',
          'CONTENT_TYPE' => 'text/plain'
        )
      end
    end
    context 'one copy + one move rule' do
      subject do
        described_class.new(app) do
          copy 'X-Forwarded-For-2', 'X-Forwarded-For'
          move 'X-Forwarded-For', 'X-New-One'
          copy 'X-Forwarded-For-2', 'X-Forwarded-For-3'
        end
      end

      before { subject.call(env) }

      it 'X-Forwared-For-2 => X-Forwared-For' do
        expect(env).to include(
          'HTTP_X_FORWARDED_FOR_1' => '1234',
          'HTTP_X_FORWARDED_FOR_2' => '123',
          'HTTP_X_NEW_ONE' => '123,12',
          'CONTENT_TYPE' => 'text/plain'
        )
        expect(env).not_to include('HTTP_X_FORWARDED_FOR' => '123')
      end
    end
  end
end
