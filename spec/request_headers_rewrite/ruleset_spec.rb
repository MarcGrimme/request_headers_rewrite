# frozen_string_literal: true

require 'spec_helper'

module RequestHeadersRewrite
  describe RuleSet do
    context '#apply' do
      let(:env) do
        Rack::MockRequest.env_for('/some/path',
                                  'HTTP_X_FORWARDED_FOR_1' => '1234',
                                  'HTTP_X_FORWARDED_FOR_2' => '123',
                                  'HTTP_X_FORWARDED_FOR' => '12',
                                  'CONTENT_TYPE' => 'text/plain')
      end
      before(:each) do
        subject.copy('X-Forwarded-For-2', 'X-Forwarded-For')
        subject.move('X-Forwarded-For', 'X-New-One')
        subject.apply!(env)
      end

      it 'copies X-Forwarded-For-2 to X-Forwarded-For and to X-New-One' do
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
