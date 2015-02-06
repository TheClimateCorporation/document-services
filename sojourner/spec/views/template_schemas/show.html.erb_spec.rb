require 'rails_helper'

RSpec.describe "template_schemas/show", :type => :view do
  let(:template_schema) { create(:template_schema) }

  before { assign(:template_schema, template_schema) }

  it "renders template_scehma attributes" do
    render

    expect(rendered).to include(template_schema.name)
    expect(rendered).to include(ERB::Util.h(beautify_json(template_schema.json_schema)))
    expect(rendered).to include(ERB::Util.h(beautify_json(template_schema.json_stub)))
    expect(rendered).to include(template_schema.created_by)
    expect(rendered).to include(template_schema.created_at.to_formatted_s)
    expect(rendered).to include(template_schema.updated_at.to_formatted_s)
  end

  it "renders a link to clone the schema" do
    render
    assert_select "a[href=?]", clone_template_schema_path(template_schema)
  end

  context "when template_schema is not immutable" do
    it "renders a link to edit the template_schema" do
      render
      assert_select "a[href=?]", edit_template_schema_path(template_schema)
    end
  end

  context "when template_schema is immutable" do
    let(:template_schema) { create(:template_schema, :immutable) }

    it "doesn't render a link to edit the template_schema" do
      render
      assert_select "a[href=?]", edit_template_schema_path(template_schema),
        count: 0
    end
  end

  it "renders a link to view the template_schemas list" do
    render
    assert_select "a[href=?]", template_schemas_path
  end
end
