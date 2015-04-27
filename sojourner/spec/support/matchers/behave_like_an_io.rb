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
require "rspec/expectations"

# Custom matcher to determine if an object can be used as an IO since no all
# Ruby classes which act like an IO inherit from `IO`, e.g., `StringIO` or
# `Tempfile`
RSpec::Matchers.define :behave_like_an_io do
  match do |obj|
    obj.respond_to?(:gets) && obj.respond_to?(:puts) && obj.respond_to?(:read)
  end
end
