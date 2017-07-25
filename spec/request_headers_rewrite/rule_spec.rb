# frozen_string_literal: true

require 'spec_helper'
require 'request_headers_rewrite/rule'
require 'byebug'

module RequestHeadersRewrite
  describe Rule do
    let(:env) do
      Rack::MockRequest.env_for('/some/path',
                                'HTTP_X_FORWARDED_FOR_1' => '1234',
                                'HTTP_X_FORWARDED_FOR_2' => '123',
                                'HTTP_X_FORWARDED_FOR' => '12',
                                'CONTENT_TYPE' => 'text/plain')
    end
    describe CopyRule do
      context '#apply!' do
        it 'copys X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2', 'X-Forwarded-For')
                         .apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR_2' => '123',
            'HTTP_X_FORWARDED_FOR' => '123,12',
            'CONTENT_TYPE' => 'text/plain'
          )
        end
        it 'copys overwriting X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2', 'X-Forwarded-For',
                              overwrite: true).apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR_2' => '123',
            'HTTP_X_FORWARDED_FOR' => '123',
            'CONTENT_TYPE' => 'text/plain'
          )
        end
        it 'copys appending X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2',
                              'X-Forwarded-For', append: true).apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR_2' => '123',
            'HTTP_X_FORWARDED_FOR' => '12,123',
            'CONTENT_TYPE' => 'text/plain'
          )
        end
      end
    end
    describe MoveRule do
      context '#apply!' do
        it 'moves X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2', 'X-Forwarded-For')
                         .apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR' => '123,12',
            'CONTENT_TYPE' => 'text/plain'
          )
          expect(env).not_to include(
            'HTTP_X_FORWARDED_FOR_2' => '123'
          )
        end
        it 'moves overwriting X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2', 'X-Forwarded-For',
                              overwrite: true).apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR' => '123',
            'CONTENT_TYPE' => 'text/plain'
          )
          expect(env).not_to include(
            'HTTP_X_FORWARDED_FOR_2' => '123'
          )
        end
        it 'moves appending X-Forwarded-For-2 env to X-Forwarded-For env' do
          described_class.new('X-Forwarded-For-2', 'X-Forwarded-For',
                              append: true).apply!(env)
          expect(env).to include(
            'HTTP_X_FORWARDED_FOR_1' => '1234',
            'HTTP_X_FORWARDED_FOR' => '12,123',
            'CONTENT_TYPE' => 'text/plain'
          )
          expect(env).not_to include(
            'HTTP_X_FORWARDED_FOR_2' => '123'
          )
        end
      end
    end
  end
end
