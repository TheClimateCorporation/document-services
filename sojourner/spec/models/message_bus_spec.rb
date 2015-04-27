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
require 'rails_helper'

RSpec.describe MessageBus do

  describe "#publish" do
    before do
      stub_request(:post, "http://message-bus.net/messages")
    end

    context "when STUB_PUBLISHING is true" do
      before do
        MessageBus::STUB_PUBLISHING = 'true'
      end

      it "doesn't do anything" do
        expect(MessageBus.publish("sojourner.rspec-test", "demo", { document_id: 1 }))
          .to eq(true)
      end
    end

    context "when STUB_PUBLISHING is false" do
      before do
        MessageBus::STUB_PUBLISHING = 'false'
      end

      it "publishes a message given a routing key, exchange, and message" do
        MessageBus.publish("sojourner.rspec-test", "demo", { document_id: 1 })
        expect(
          a_request(:post, "http://message-bus.net/messages")
            .with(:body => '{"routing_key":"sojourner.rspec-test","exchange":"demo","data":"{\"document_id\":1}"}')
        ).to have_been_made
      end
    end
  end
end
