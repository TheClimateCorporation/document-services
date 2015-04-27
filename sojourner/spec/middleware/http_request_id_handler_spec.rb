# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
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
