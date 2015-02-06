require 'rails_helper'

RSpec.describe DocstoreConnector, :type => :model do
  let(:request_id) { 'request-id' }

  let(:auth_headers) {
    {
    'X-User-Id' => "1337",
    'X-Authenticated-User-Id' => "1337",
    'Authorization' => 'Bearer 988f2fb4-5c83-4979-89cf-6df35a99614d'
    }
  }
  let(:connector) { DocstoreConnector.new(request_id: request_id, request_headers: auth_headers) }
  let(:document_id) { "pretend-im-a-doc-id" }

  describe "create_id_reservation" do
    context "with a status: 200 response from docstore" do
      before do
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")
          .with(headers: {'X-Request-Id' => request_id})
          .to_return(body: { 'document_id' => document_id, enabled: true}.to_json)
      end

      let(:response) { connector.create_id_reservation }

      it "returns a document_id" do
        expect(response['document_id']).to eq(document_id)
      end

      it "returns the enable status" do
        expect(response['enabled']).to eq(true)
      end
    end

    context "with a non-200 response" do
      before do
        stub_request(:post, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations")
          .to_return(status: 500)
      end

      it "raises an error" do
        expect {subject.create_id_reservation}.to raise_error(Faraday::ClientError)
      end
    end
  end

  describe "disable_id_reservation" do
    context "with a status: 200 response from docstore" do
      before do
        stub_request(:put, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations/#{document_id}")
          .with(headers: {'X-Request-Id' => request_id})
          .to_return(body: { 'document_id' => document_id, enabled: false }.to_json)
      end

      let(:response) { connector.disable_id_reservation(document_id) }

      it "returns a document_id" do
        expect(response['document_id']).to eq(document_id)
      end

      it "returns the enable status" do
        expect(response['enabled']).to eq(false)
      end
    end

    context "with a non-200 response" do
      before do
        stub_request(:put, "#{DocstoreConnector::DOCSTORE_URL}/id_reservations/#{document_id}")
          .to_return(status: 500)
      end

      it "raises an error" do
        expect {subject.disable_id_reservation(document_id)}.to raise_error(Faraday::ClientError)
      end
    end
  end

  describe "#store_document" do
    let(:endpoint) {  "#{DocstoreConnector::DOCSTORE_URL}/documents" }
    let(:params) do
      {
        created_by: 'me',
        document_id: 'document-id',
        name: 'file-name',
        mime_type: 'text/plain',
        owner_id: '1234',
        owner_type: 'User',
        document: StringIO.new("hello world")
      }
    end

    before do
      stub_request(:post, endpoint).with(headers: {'X-Request-Id' => request_id})
      connector.store_document(params)
    end

    it "sends provided attributes as the document attributes" do
      expect(a_request(:post, endpoint).with do |req|
        document_attributes = SpecHelpers::MultipartRequestParser
          .parse(req)
          .deep_symbolize_keys[:document_attributes]
                                            # CHANGE-ME :created_by
        document_attributes == params.except(:document, :mime_type, :name)
      end).to have_been_made
    end

    it "sends provided document as the document's content" do
      expect(a_request(:post, endpoint).with do |req|
        document = SpecHelpers::MultipartRequestParser.parse(req)["document_content"]

        params[:document].rewind
        document[:tempfile].read == params[:document].read &&
          document[:filename] == params[:name] &&
          document[:type] == params[:mime_type]
      end).to have_been_made
    end
  end
end
