require 'rails_helper'

RSpec.describe "template_schemas/index", :type => :view do
  let(:template_schema) { create(:template_schema) }

  before { assign(:template_schemas, [template_schema]) }

  it "renders a list of template_schemas" do
    render

    assert_select "td", :text => template_schema.name
    assert_select "td", :text => template_schema.created_by
    assert_select "td", :text => template_schema.created_at.to_formatted_s
    assert_select "td", :text => template_schema.updated_at.to_formatted_s
    assert_select "td>a[href=?]", template_schema_path(template_schema)
  end

  context "when an entry is not immutable" do
    it "renders edit and destroy links" do
      render

      assert_select "td>a[href=?]", edit_template_schema_path(template_schema)
      assert_select "td>a[data-method=?][href=?]", "delete",
        template_schema_path(template_schema)
    end
  end

  context "when an entry is immutable" do
    let(:template_schema) { create(:template_schema, :immutable) }

    it "doesn't render edit and destroy links" do
      render

      assert_select "td>a[href=?]", edit_template_schema_path(template_schema),
        count: 0
      assert_select "td>a[data-method=?][href=?]", "delete",
        template_schema_path(template_schema), count: 0
    end

    it "does render a clone link" do
      render
      assert_select "td>a[href=?]", clone_template_schema_path(template_schema)
    end
  end

  it "renders a link to create template_schemas" do
    render

    assert_select "a[href=?]", new_template_schema_path
  end
end
