require 'rails_helper'

RSpec.describe DocumentsController, :type => :controller do

  describe 'POST to /documents' do
    let(:upload) { fixture_file_upload('empty.pdf', 'application/pdf') }

    before { request_as('me') }

    context 'with good data' do
      context "when no owner is specified" do
        before { post :create, document_content: upload }

        let(:document) { Document.find(JSON.parse(response.body)['id']) }

        it 'creates a document record' do
          expect(document).to_not be_nil
        end

        it 'associates the record with an IdReservation' do
          expect(document.reservation).to_not be_nil
        end

        it 'returns a 201 Created response' do
          expect(response.status).to eq 201
        end

        it 'assigns the correct created_by' do
          expect(document.created_by).to eq('me')
        end

        it 'defaults owner to the current user id' do
          expect(document.owner_type).to eq('User')
          expect(document.owner_id).to eq('me')
        end

        it 'saves the file' do
          expect(document.file_saved?).to eq(true)
        end

        it 'should infer the mime type from the file' do
          expect(document.mime_type).to eq('application/pdf')
        end

        it 'infers the name from the file' do
          expect(document.name).to eq('empty.pdf')
        end
      end

      context "when a document_owner is specified" do
        let(:document_attributes) { {owner_type: 'foobar', owner_id: 1} }

        before do
          post :create, document_attributes: document_attributes, document_content: upload
        end

        it 'assigns owner if specified' do
          document_with_owner = Document.find(JSON.parse(response.body)['id'])

          expect(document_with_owner.owner_type).to eq document_attributes[:owner_type]
          expect(document_with_owner.owner_id).to eq document_attributes[:owner_id].to_s
        end
      end

      context 'when supplying a document_id' do
        let!(:reservation) { IdReservation.create! }

        let(:document_attributes) { {document_id: reservation.document_id} }

        context "with a valid reservation" do
          it 'does not create a new reservation' do
            expect {
              post :create, document_attributes: document_attributes, document_content: upload
            }.to_not change { IdReservation.count }
          end

          it 'associates the document with the reservation' do
            post :create, document_attributes: document_attributes, document_content: upload
            doc = Document.find(JSON.parse(response.body)['id'])

            expect(doc.reservation).to eq(reservation)
          end
        end

        context "with an invalid document_id" do
          it 'gives a useful error with a bad reservation' do
            post :create, document_attributes: {document_id: 'im-not-reserved'},
              document_content: upload
            body = JSON.parse(response.body)

            expect(response.status).to eq(400)
            expect(body['errors']).to include("document_id" => ["was specified" \
              " but does not refer to a valid IdReservation"])
          end

          it 'gives a useful error with a used reservation' do
            #first time should work
            post :create, document_attributes: document_attributes, document_content: upload
            #duplicate should error
            post :create, document_attributes: document_attributes, document_content: upload
            body = JSON.parse(response.body)

            expect(response.status).to eq(400)
            expect(body['errors']).to include("document_id" => ["refers to an " \
              "IdReservation which has already been used"])
          end
        end
      end
    end

    context 'without a file' do
      before { post :create }

      it 'returns a 400 Bad Request error' do
        expect(response.status).to eq 400
      end

      it 'gives an error message' do
        expect(JSON.parse(response.body)['errors']).to include("file"=>["can't be blank"])
      end
    end

    context 'if the document fails to store' do
      it 'returns a 500 Internal Server Error error' do
        # if the test is written for any_instance_of Document, it will not
        # pass when a LocalDocument is instantiated. Dunno why.
        expect_any_instance_of(Document::DEFAULT_TYPE[Rails.env].constantize)
          .to receive(:put!).and_raise("an error!")

        post :create, document_content: upload
        expect(response.status).to eq 500
      end
    end
  end
end
