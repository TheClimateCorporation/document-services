require "rails_helper"

RSpec.describe HttpRequestIdHandler do
  let(:env) { Rack::MockRequest.env_for('/') }
  let(:app) { ->(env) { [200, env, 'resp body'] } }
  let(:stack) { HttpRequestIdHandler.new(app) }

  before { env['HTTP_X_HTTP_REQUEST_ID'] = 'http-request-id-value' }

  context "when 'X-REQUEST-ID' header is present" do
    before { env['HTTP_X_REQUEST_ID'] = 'request-id-value' }

    it "doesn't override it's value" do
      stack.call(env)
      expect(env['HTTP_X_REQUEST_ID']).to eq('request-id-value')
    end
  end

  context "when 'X-Request-Id' header is blank" do
    it "override it's value with the 'X-Http-Request-Id' header value" do
      stack.call(env)
      expect(env['HTTP_X_REQUEST_ID']).to eq('http-request-id-value')
    end
  end
end
