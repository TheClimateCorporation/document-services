require 'rails_helper'

RSpec.describe DocumentAuthorizor, :type => :model do

  describe "self.authorized?" do
    context "when the document owner_type is 'anyone' " do
      let(:anyone_doc) { create(:document, owner_type: 'anyone') }

      it "allows read" do
        expect(DocumentAuthorizor.authorized?(anyone_doc, SecureRandom.hex(8), :read))
          .to eq(true)
      end
    end

    context "when the document owner_type is 'user' " do
      let(:user_doc) { create(:document, owner_type: 'user') }

      it "allows read if the requestor is the document owner" do
        expect(DocumentAuthorizor.authorized?(user_doc, user_doc.owner_id, :read))
          .to eq(true)
      end

      it "allows read if the requestor is the document creator" do
        expect(DocumentAuthorizor.authorized?(user_doc, user_doc.created_by, :read))
          .to eq(true)
      end

      it "does not allow read for anyone else" do
        expect(DocumentAuthorizor.authorized?(user_doc, SecureRandom.hex(8), :read))
          .to eq(false)
      end
    end
  end
end
