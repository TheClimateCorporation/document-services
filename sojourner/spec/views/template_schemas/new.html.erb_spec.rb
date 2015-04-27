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
