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
