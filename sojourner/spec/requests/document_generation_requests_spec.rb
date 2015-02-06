require 'rails_helper'

RSpec.describe "Document Generation Requests", type: :request do
  subject { response }

  before { request_as 'me' }

  describe "POST /generate" do
    context "with valid params" do
      let(:template_single_version) { create(:template_single_version) }
      let(:input_data) { template_single_version.template_schema.json_stub }

      before do
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")
          .to_return(body: {'document_id' => 'document_id'}.to_json, :status => 200)
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/documents")
          .to_return(body: {'document_id' => 'document_id'}.to_json, :status => 200)
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
          .to_return(:body => {'document_id' => 'document_id'}.to_json)

        stub_request(:put, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")

        post '/generate'
      end

      describe "response status" do
        subject { response.status }
        it { is_expected.to be(400) }
      end
    end
  end
end
