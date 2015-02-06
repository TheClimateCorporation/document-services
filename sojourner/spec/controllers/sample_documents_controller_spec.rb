require "rails_helper"

RSpec.describe SampleDocumentsController, type: :controller do
  let(:tsv)  { create(:template_single_version) }
  before { request_as(1337) }

  describe "POST create" do
    before do
      allow_any_instance_of(TemplateSingleVersion)
        .to receive(:render)
        .and_return(instance_double("Tempfile"))

      post :create, template_id: tsv.template_id, version_version: tsv.version
    end

    it "creates a sample_document for the template" do
      expect(tsv.sample_document).to be_an_instance_of(SampleDocument)
    end

    context "when a sample document already exists" do
      it "does not create another" do
        expect {
          #this will be a duplicate since we've already posted once
          post :create, template_id: tsv.template_id, version_version: tsv.version
        }.not_to change{SampleDocument.count}
      end

      it "adds an error message" do
        post :create, template_id: tsv.template_id, version_version: tsv.version
        expect(flash['alert']).to eq({:template_version_id=>["the template_version" \
          " already has a sample document"]})
      end
    end
  end

end
