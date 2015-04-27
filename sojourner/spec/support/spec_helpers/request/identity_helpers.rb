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
module SpecHelpers
  module Request
    # RSpec request specs helpers to make requests as an identified user.
    #
    # Example:
    #
    #   RSpec.describe "My request" do
    #     it "sends an identified request" do
    #       request_as "me"
    #       get :index
    #       expect(@controller.current_user_id).to eq("me)
    #     end
    #   end
    #
    # See `ApplicationController` for implementation details
    module IdentityHelpers
      extend ActiveSupport::Concern

      included do
        after { @user_id = nil }
      end

      def request_as(user_id)
        @user_id = user_id
      end

      # %w(get post patch put head delete).each do |method|
      #   define_method(method) do |path, parameters = nil, headers_or_env = {}|
      #     CHANGE-ME to stuff that's useful
      #   end
      # end
    end
  end
end
