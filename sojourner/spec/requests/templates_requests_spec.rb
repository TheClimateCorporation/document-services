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

RSpec.describe "Templates Requests", type: :request do
  subject { response }
  before { request_as(1337) }
  describe "GET /templates" do
    before { get "/templates" }

    it { is_expected.to render_template('templates/index') }
    it { is_expected.to be_success }
  end

  describe "GET /templates/:id" do
    let(:template) { create(:template) }

    before { get "/templates/#{template.id}" }

    it { is_expected.to render_template('templates/show') }
    it { is_expected.to be_success }
  end

  describe "GET /templates/new" do
    before { get "/templates/new" }

    it { is_expected.to render_template('templates/new') }
    it { is_expected.to be_success }
  end

  describe "POST /templates" do
    context "with valid params" do
      let(:template) { Template.last }

      before { post "/templates", template: generate(:template_valid_request_params) }

      it { is_expected.to redirect_to("/templates/#{template.id}") }
    end

    context "with valid params" do
      before { post "/templates", template: generate(:template_invalid_request_params) }

      it { is_expected.to render_template("templates/new") }
    end
  end
end
