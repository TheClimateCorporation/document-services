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

RSpec.describe TemplatesController, type: :controller do
  before { request_as(1337) }
  describe "GET index" do
    it "assign all templates to @templates" do
      template = create(:template, :single)
      get :index
      expect(assigns(:templates)).to eq([template])
    end
  end

  describe "GET show" do
    it "assigns the template for the given id to @template" do
      template = create(:template, :single)
      get :show, id: template.id
      expect(assigns(:template)).to eq(template)
    end
  end

  describe "GET new" do
    it "assigns an initialized template to @template" do
      get :new
      expect(assigns(:template)).to be_a_new(Template)
    end
  end

  describe "POST create" do
    context "with valid params" do
      let(:template) { Template.last }
      let(:valid_params) { generate(:template_valid_request_params) }

      before { post :create, template: valid_params }

      it "creates a template with the given params" do
        expect(template.attributes).to include(valid_params)
      end

      it "sets created_by on the created template to the current user id" do
        expect(template.created_by.to_i).to eq(controller.current_user_id)
      end

      it "assigns the created template to @template" do
        expect(assigns(:template)).to eq(template.becomes(Template))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { generate(:template_invalid_request_params) }

      it "doesn't creates a template" do
        expect do
          post :create, template: invalid_params
        end.to_not change { Template.count }
      end

      it "assigns the invalid template schema to @template_schema" do
        post :create, template: invalid_params
        expect(assigns(:template)).to be_a(Template)
      end
    end
  end
end
