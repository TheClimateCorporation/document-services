require 'rails_helper'

RSpec.describe ReadLinksBatch, :type => :model do
  let(:user)       { double(uid: 'me') }
  let(:other_user) { double(uid: 'you') }

  let(:my_doc)   { create(:document, created_by: user.uid) }
  let(:your_doc) { create(:document, created_by: other_user.uid) }
  let(:our_doc)  { create(:document, created_by: user.uid, owner_id: other_user.uid) }
  let(:bad_doc_id) { "not-a-doc-id" }

  let(:doc_ids)    { [my_doc.document_id, your_doc.document_id, our_doc.document_id, bad_doc_id] }

  subject { ReadLinksBatch.new(doc_ids, user.uid) }

  let(:read_links) { subject.authorized_read_links }

  describe "authorized_read_links" do
    let(:my_doc_link_info)   { read_links.find { |info| info[:document_id] == my_doc.document_id } }
    let(:your_doc_link_info) { read_links.find { |info| info[:document_id] == your_doc.document_id } }
    let(:our_doc_link_info)  { read_links.find { |info| info[:document_id] == our_doc.document_id } }
    let(:bad_doc_link_info)  { read_links.find { |info| info[:document_id] == bad_doc_id } }

    it "should create read_links for authorized documents" do
      expect(my_doc_link_info['read_link']).not_to be_nil
      expect(my_doc_link_info['status']).to eq(:success)

      expect(our_doc_link_info['read_link']).not_to be_nil
      expect(our_doc_link_info['status']).to eq(:success)
    end

    it "should not create read_links for unauthorized/invalid documents" do
      expect(your_doc_link_info['read_link']).to be_nil
      expect(bad_doc_link_info['read_link']).to be_nil
    end

    it "should file errors for unauthorized documents" do
      expect(your_doc_link_info['status']).to eq(:unauthorized)
      expect(your_doc_link_info['error'])
        .to eq("User #{user.uid} not authorized to read document #{your_doc.document_id}")
    end

    it "should file errors for document_ids that don't exist" do
      expect(bad_doc_link_info['status']).to eq(:not_found)
      expect(bad_doc_link_info['error'])
        .to eq("No document found for document_id: #{bad_doc_id}")
    end
  end

  describe "to_json" do
    it "doesn't flip out when rails controller tries to pass it an options hash" do
      expect{
        subject.to_json(option: 'literally anything')
      }.not_to raise_error
    end

    it "returns only the read links" do
      read_links
      expect(subject.to_json).to eq(read_links.to_json)
    end
  end
end
