require 'rails_helper'

RSpec.describe "template_schemas/edit", :type => :view do
  let(:template_schema) { create(:template_schema) }

  before { assign(:template_schema, template_schema) }

  it "renders the edit template_schema form" do
    render

    assert_select "form[action=?][method=?]", template_schema_path(template_schema), "post" do
      assert_select "input#template_schema_name[name=?][value=?]",
        "template_schema[name]", template_schema.name

      assert_select "textarea#template_schema_json_schema_properties[name=?]",
        "template_schema[json_schema_properties]", text: ERB::Util.h(template_schema.json_schema_properties)

      assert_select "textarea#template_schema_json_stub[name=?]",
        "template_schema[json_stub]", text: ERB::Util.h(template_schema.json_stub)
      end
  end

  it "renders a link to view the template_schema" do
    render
    assert_select "a[href=?]", template_schema_path(template_schema)
  end

  it "renders a link to view the template_schemas list" do
    render
    assert_select "a[href=?]", template_schemas_path
  end
end
