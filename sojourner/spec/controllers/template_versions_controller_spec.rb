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

RSpec.describe TemplateVersionsController, type: :controller do
  before { request_as(1337) }
  context "when parent template is a template single" do
    let(:template) { create(:template, :single) }

    describe "GET new" do
      it "assigns the template for the given template id to @template" do
        get :new, template_id: template.id
        expect(assigns(:template)).to eq(template)
      end

      it "assigns an initialized template single version to @template_version" do
        get :new, template_id: template.id
        expect(assigns(:template_version)).to be_a(TemplateSingleVersion)
      end

      it "assigns all template schemas to @template_schemas" do
        template_schemas = create_list(:template_schema, 1)
        get :new, template_id: template.id
        expect(assigns(:template_schemas)).to eq(template_schemas)
      end
    end

    describe "POST create" do
      context "with valid params" do
        let(:template_version_params) do
          generate(:template_single_version_valid_request_params)
        end

        it "creates a template single version for the given template" do
          expect {
            post :create, template_id: template.id,
              template_version: template_version_params
          }.to change { template.versions.count }.by(1)
        end

        it "sets created_by on the created template version to the current user id" do
          post :create, template_id: template.id,
            template_version: template_version_params

          expect(TemplateSingleVersion.last.created_by.to_i).to eq(controller.current_user_id)
        end

        it "assigns the created template single version to @template_version" do
          post :create, template_id: template.id,
            template_version: template_version_params

          expect(assigns(:template_version)).to eq(TemplateSingleVersion.last)
        end
      end

      context "with invalid params" do
        let(:template_version_params) do
          generate(:template_single_version_invalid_request_params)
        end

        it "doesn't create a template single version" do
          expect {
            post :create, template_id: template.id,
              template_version: template_version_params
          }.to_not change { TemplateSingleVersion }
        end

        it "assigns all template schemas to @template_schemas" do
          template_schemas = create_list(:template_schema, 1)
          post :create, template_id: template.id,
            template_version: template_version_params
          expect(assigns(:template_schemas)).to eq(template_schemas)
        end
      end
    end
  end
end
