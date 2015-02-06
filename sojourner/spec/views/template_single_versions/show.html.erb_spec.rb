require 'rails_helper'

RSpec.describe "template_single_versions/show", type: :view do
  let(:tsv) { create(:template_single_version)}

  before do
    assign(:template, tsv.template)
    assign(:template_version, tsv)
  end

  it "renders the template id and the version number" do
    render

    assert_select 'h1', text: "Template #{tsv.template.id}: Version #{tsv.version}"
  end

  it "renders the template version attributes" do
    render

    expect(rendered).to include(tsv.created_by)
    expect(rendered).to include(tsv.created_at.to_formatted_s)
    expect(rendered).to include(tsv.updated_at.to_formatted_s)
    expect(rendered).to include(tsv.ready_for_production?.to_s)
  end

  it "renders a link to the template file" do
    render
    assert_select 'a[href=?]', tsv.file_location.read_link
  end

  context "if a sample document exists" do
    let(:sample_doc) { instance_double("SampleDocument", read_link: "I am a read link!") }
    before { allow(tsv).to receive(:sample_document).and_return(sample_doc) }

    it "renders a link to the sample document" do
      render
      assert_select 'a[href=?]', tsv.sample_document.read_link
    end
  end

  context "if a sample document doesn't exist" do
    it "renders a link generate a sample document" do
      render
      assert_select 'a[href=?]', template_version_sample_document_path(
        template_id: tsv.template_id, version_version: tsv.version)
    end
  end

  it "renders the json schema for the template version" do
    render
    expect(rendered)
      .to include(ERB::Util.h(beautify_json(tsv.template_schema.json_schema)))
  end

  it "renders the input_data stub" do
    render
    expect(rendered)
      .to include(ERB::Util.h(beautify_json(tsv.template_schema.json_stub)))
  end

  it "renders the permissions history" do
    render

    assert_select 'td', text: tsv.permission_changes.first.created_by
    assert_select 'td', text: tsv.permission_changes.first.created_at.to_formatted_s
    assert_select 'td', text: tsv.permission_changes.first.ready_for_production?
  end

end
