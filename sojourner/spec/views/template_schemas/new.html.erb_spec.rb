require 'rails_helper'

RSpec.describe "template_schemas/new", :type => :view do
  before {assign(:template_schema, TemplateSchema.new) }

  it "renders new template_schema form" do
    render

    assert_select "form[action=?][method=?]", template_schemas_path, "post" do
      assert_select "input#template_schema_name[name=?]", "template_schema[name]"
      assert_select "textarea#template_schema_json_schema_properties[name=?]", "template_schema[json_schema_properties]"
      assert_select "textarea#template_schema_json_stub[name=?]", "template_schema[json_stub]"
    end
  end

  it "renders a link to view the template_schemas list" do
    render

    assert_select "a[href=?]", template_schemas_path
  end
end
