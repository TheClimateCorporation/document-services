require 'rails_helper'

RSpec.describe "templates/index", :type => :view do
  let(:template) { create(:template, :single) }

  before { assign(:templates, [template]) }

  it "renders a list of templates" do
    render

    assert_select "td", :text => template.id
    assert_select "td", :text => template.name
    assert_select "td", :text => template.type
    assert_select "td>a[href=?]", template_path(template)
  end

  it "renders a link to create template_schemas" do
    render

    assert_select "a[href=?]", new_template_path
  end
end
