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

RSpec.describe "Template Schemas Requests", :type => :request do
  let(:template_schema) { create(:template_schema) }
  before { request_as(1337) }

  subject { response }

  describe "GET /template_schemas" do
    before { get "/template_schemas" }

    it { is_expected.to render_template('template_schemas/index') }
    it { is_expected.to be_success }
  end

  describe "GET /template_schemas/:id" do
    before { get "/template_schemas/#{template_schema.id}" }

    it { is_expected.to render_template('template_schemas/show') }
    it { is_expected.to be_success }
  end

  describe "GET /template_schemas/new" do
    before { get "/template_schemas/new" }

    it { is_expected.to render_template('template_schemas/new') }
    it { is_expected.to be_success }
  end

  describe "GET /template_schemas/:id/edit" do
    before { get "/template_schemas/#{template_schema.id}/edit" }

    it { is_expected.to render_template('template_schemas/edit') }
    it { is_expected.to be_success }
  end

  let(:valid_params) { generate(:template_schema_valid_request_params) }
  let(:invalid_params) { generate(:template_schema_invalid_request_params) }

  describe "POST /template_schemas" do
    context "with valid params" do
      let(:template_schema) { TemplateSchema.last }

      before { post "/template_schemas", {template_schema: valid_params} }

      it { is_expected.to redirect_to("/template_schemas/#{template_schema.id}") }
    end

    context "with invalid params" do
      before { post "/template_schemas", {template_schema: invalid_params} }

      it { is_expected.to render_template("template_schemas/new") }
    end
  end

  describe "PUT /template_schemas/:id" do
    context "with valid params" do
      before { put "/template_schemas/#{template_schema.id}", {template_schema: valid_params} }

      it { is_expected.to redirect_to("/template_schemas/#{template_schema.id}") }
    end

    context "with invalid params" do
      before { put "/template_schemas/#{template_schema.id}", {template_schema: invalid_params} }

      it { is_expected.to render_template("template_schemas/edit") }
    end
  end

  describe "GET /template_schemas/:id/clone" do
    before { get "/template_schemas/#{template_schema.id}/clone" }

    it { is_expected.to render_template("template_schemas/new") }
  end

  describe "DELETE /template_schemas/:id" do
    before { delete "/template_schemas/#{template_schema.id}" }

    it { is_expected.to redirect_to("/template_schemas") }
  end
end
