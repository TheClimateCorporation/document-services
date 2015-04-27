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

RSpec.describe DocumentLinksController, :type => :controller do
  let(:user) { double(uid: 'me') }
  let(:other_user) { double(uid: 'you') }

  before do
    request_as(user.uid)
  end

  describe 'POST to /document_links' do
    subject { build(:document, :s3_document, created_by: user.uid) }

    let(:uri) { instance_double("URI::HTTPS", to_s: "http://www.example.com/rspec/test?some=query&string=of%stuff") }
    let(:s3_object) { instance_double("AWS::S3::S3Object", write: true, url_for: uri) }

    let(:bad_doc_id) { "not-a-doc-id" }

    before do
      allow_any_instance_of(S3Document).to receive(:s3_object).and_return(s3_object)
    end

    context 'one document_id is POSTed' do
      let(:body) { JSON.parse(response.body) }
      let(:link_info) { body.first }

      context 'with an S3Document that does not exist' do
        before do
          post :create, document_ids: [bad_doc_id]
        end

        it 'returns an informative error' do
          expect(link_info['status']).to eq('not_found')
          expect(link_info['error'])
            .to eq("No document found for document_id: #{bad_doc_id}")
        end

        it 'returns status success' do
          expect(response.status).to eq(200)
        end
      end

      context 'with an S3Document that does exist' do
        context "when a user is authorized to read a document" do
          before do
            subject.save!
            post :create, document_ids: [subject.document_id]
          end

          it 'returns a link for an s3document that exists' do
            expect(link_info['read_link']).to eq(uri.to_s)
          end

          it "returns status ok" do
            expect(response.status).to eq(200)
          end
        end

        context "when a user is not authorized to read a document" do
          before do
            request_as(other_user.uid)
            subject.save!
            post :create, document_ids: [subject.document_id]
          end

          it 'returns unauthorized, and an error' do
            expect(link_info['status']).to eq('unauthorized')
            expect(link_info['error'])
              .to eq("User #{other_user.uid} not authorized to read document #{subject.document_id}")
          end

          it 'returns status success' do
            expect(response.status).to eq(200)
          end
        end
      end
    end

    context 'multiple document_ids POSTed' do
      context 'with a mix of valid and invalid document_ids' do
        before do
          subject.save
          post :create, document_ids: [bad_doc_id, subject.document_id]
        end

        let(:body) { JSON.parse(response.body) }

        it 'returns links for valid ids' do
          link_info = body.find { |obj| obj['document_id'] == subject.document_id }
          expect(link_info['read_link']).to eq(uri.to_s)
        end

        it 'returns an error for for invalid id' do
          link_info = body.find { |obj| obj['document_id'] == bad_doc_id }

          expect(link_info['status']).to eq('not_found')
          expect(link_info['error'])
            .to eq("No document found for document_id: #{bad_doc_id}")
        end

        it 'returns status success' do
          expect(response.status).to eq(200)
        end
      end

      context 'with a mix of both authorized and unauthorized documents' do
        let(:my_doc) { create(:document, :s3_document, created_by: user.uid) }
        let(:your_doc) { create(:document, :s3_document, created_by: other_user.uid) }

        before do
          post :create, document_ids: [my_doc.document_id, your_doc.document_id]
        end

        let(:body) { JSON.parse(response.body) }

        it 'returns a link for the authorized document' do
          link_info = body.find { |obj| obj['document_id'] == my_doc.document_id }
          expect(link_info['read_link']).to eq(uri.to_s)
        end

        it 'returns an error for the unauthorized document' do
          link_info = body.find { |obj| obj['document_id'] == your_doc.document_id }

          expect(link_info['status']).to eq('unauthorized')
          expect(link_info['error'])
            .to eq("User #{user.uid} not authorized to read document #{your_doc.document_id}")
        end

        it 'returns status success' do
          expect(response.status).to eq(200)
        end
      end

      context 'with multiple valid, authorized document_ids' do
        let(:my_doc) { create(:document, :s3_document, created_by: user.uid) }
        let(:your_doc) { create(:document, :s3_document, created_by: other_user.uid, owner_id: user.uid) }

        before do
          post :create, document_ids: [my_doc.document_id, your_doc.document_id]
        end

        let(:body) { JSON.parse(response.body) }

        it 'returns a links for all the document_ids' do
          link_info = body.find { |obj| obj['document_id'] == my_doc.document_id }
          link_info2 = body.find { |obj| obj['document_id'] == your_doc.document_id }

          expect(link_info['read_link']).to eq(uri.to_s)
          expect(link_info2['read_link']).to eq(uri.to_s)
        end

        it 'returns status success' do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
