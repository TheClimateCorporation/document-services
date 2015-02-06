require 'rails_helper'

RSpec.describe IdReservationsController, :type => :controller do

  describe "POST #create" do
    it "returns http success" do
      post :create
      expect(response).to be_success
    end
  end

  describe "PUT #disable" do
    let(:r) { IdReservation.create! }

    context "when the document_id is valid" do
      it "returns http success" do
        put :disable, document_id: r.document_id
        expect(response).to be_success
      end
    end

    context "when the document_id is not valid" do
      it "returns bad request" do
        put :disable, document_id: 1234
        expect(response.code).to eq("400")
      end
    end
  end

end
