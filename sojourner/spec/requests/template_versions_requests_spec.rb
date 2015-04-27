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

RSpec.describe "Template Versions Requests", type: :request do
  subject { response }
  before { request_as(1337) }

  context "when template is a template single" do
    let(:template) { create(:template, :single) }

    describe "GET /templates/:template_id/v/new" do
      before { get "/templates/#{template.id}/v/new" }

      it { is_expected.to render_template('template_single_versions/new') }
      it { is_expected.to be_success }
    end

    describe "POST /templates/:template_id/v" do
      before do
        post "/templates/#{template.id}/v",
          template_version: template_version_params
      end

      context "with valid params" do
        let(:template_version_params) do
          generate(:template_single_version_valid_request_params)
        end

        it { is_expected.to redirect_to("/templates/#{template.id}") }
      end

      context "with invalid params" do
        let(:template_version_params) do
          generate(:template_single_version_invalid_request_params)
        end

        it { is_expected.to render_template("template_single_versions/new") }
      end
    end
  end
end
