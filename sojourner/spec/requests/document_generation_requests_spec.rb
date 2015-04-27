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

RSpec.describe "Document Generation Requests", type: :request do
  subject { response }

  before { request_as 'me' }
  let(:document_id) { 'a-document-id' }

  describe "POST /generate" do
    context "with valid params" do
      let(:template_single_version) { create(:template_single_version) }
      let(:input_data) { template_single_version.template_schema.json_stub }

      before do
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")
          .to_return(body: {'document_id' => document_id}.to_json, :status => 200)
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/documents")
          .to_return(body: {'document_id' => document_id}.to_json, :status => 200)
        stub_request(:post, "http://message-bus.net/messages")

        post '/generate', template_id: template_single_version.template.id,
          input_data: input_data, schema_id: template_single_version.template_schema_id,
          document_name: 'a-document'
      end

      it { is_expected.to be_success }
    end

    context "with invalid params" do
      before do
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")
          .to_return(:body => {'document_id' => document_id}.to_json)

        stub_request(:put, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations/#{document_id}")
          .to_return(body: {'document_id' => document_id, 'enabled' => false}.to_json, status: 200)

        post '/generate'
      end

      describe "response status" do
        subject { response.status }
        it { is_expected.to be(400) }
      end
    end
  end
end
