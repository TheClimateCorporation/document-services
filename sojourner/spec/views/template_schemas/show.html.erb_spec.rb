# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
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
