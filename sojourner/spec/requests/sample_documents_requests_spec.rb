require 'rails_helper'

RSpec.describe "SampleDocument generation requests", :type => :request do
  subject { response }
  before { request_as(1337) }

  describe "POST /generate" do
    let(:template_schema) { create(:template_schema, json_stub: {root: {body: ['item']}}.to_json) }
    let(:tsv) { create(:template_single_version, template_schema: template_schema) }

    context "if the document saves correctly" do
      before do
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
      end

      it { is_expected.to redirect_to("/templates/#{tsv.template_id}/v/#{tsv.version}")}

    end

    context "if an error occurs in saving the sample document" do
      before do
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
        #second time should fail
        post "templates/#{tsv.template_id}/v/#{tsv.version}/sample_document"
      end

      it "redirects with an error message" do
        is_expected.to redirect_to("/templates/#{tsv.template_id}/v/#{tsv.version}")
        expect(flash['alert']).to eq({:template_version_id=>["the template_version " \
          "already has a sample document"]})
      end

    end
  end

end
