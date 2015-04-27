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
# Seems some applications actually use a 'X-Http-Request-Id` header to specify
# the request id instead of the Rails standard 'X-Request-Id`. This middleware
# forwards the 'X-Http-Request-Id` value to `X-Request-Id' if not set.
#
# See: http://api.rubyonrails.org/classes/ActionDispatch/RequestId.html
class HttpRequestIdHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    env["HTTP_X_REQUEST_ID"] ||= env["HTTP_X_HTTP_REQUEST_ID"]
    @app.call(env)
  end
end
