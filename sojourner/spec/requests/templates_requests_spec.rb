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
