require 'rails_helper'

RSpec.describe TemplatePermissionChangesController, :type => :controller do
  before { request_as(1337) }
  describe "POST create" do
    let(:tsv) { create(:template_single_version) }

    it "creates a permission change" do
      expect { post :create,
        template_id: tsv.template.id,
        version_version: tsv.version,
        ready_for_production: true }.to change { tsv.permission_changes.count }.by 1
    end
  end
end
