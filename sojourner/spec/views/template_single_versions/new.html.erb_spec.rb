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

RSpec.describe "template_single_versions/new", type: :view do
  let(:template) { create(:template, :single) }
  let(:template_version) { TemplateSingleVersion.new }
  let(:template_schemas) { create_list(:template_schema, 1) }

  before do
    assign(:template, template)
    assign(:template_version, template_version)
    assign(:template_schemas, template_schemas)
  end

  it "render new template single version form" do
    render

    assert_select "form[action=?][method=?]", template_versions_path(template), "post" do
      assert_select "select#template_version_template_schema_id[name=?]",
        "template_version[template_schema_id]"
      assert_select "input#template_version_file[name=?]",
        "template_version[file]"
    end
  end

  it "renders a list of selectable template schemas" do
    render

    assert_select "select#template_version_template_schema_id" do
      template_schemas.each do |template_schema|
        assert_select "option[value=?]", template_schema.id,
          text: template_schema.name
      end
    end
  end

  it "renders a link to view the parent template" do
    render

    assert_select "a[href=?]", template_path(template)
  end
end
