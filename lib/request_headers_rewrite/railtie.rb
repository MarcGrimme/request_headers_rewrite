# frozen_string_literal: true

module RequestHeadersMiddleware
  # The Railtie triggering a setup from RAILs to make it configurable
  class Railtie < ::Rails::Railtie
    initializer 'request_headers_middleware.insert_middleware' do
      config.app_middleware.insert_before ActionDispatch::RequestId,
                                          RequestHeadersRewrite::Middleware
    end
  end
end
