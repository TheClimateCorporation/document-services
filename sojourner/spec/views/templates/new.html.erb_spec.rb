require 'rails_helper'

RSpec.describe "templates/new", :type => :view do
  before {assign(:template, Template.new) }

  it "renders new template form" do
    render

    assert_select "form[action=?][method=?]", templates_path, "post" do
      assert_select "input#template_name[name=?]", "template[name]"
    end
  end

  it "renders a link to view the templates list" do
    render

    assert_select "a[href=?]", templates_path
  end
end
