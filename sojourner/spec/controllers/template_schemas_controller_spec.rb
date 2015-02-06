require "rails_helper"

RSpec.describe TemplateSchemasController, type: :controller do
  before { request_as(1337) }
  describe "GET index" do
    it "assigns available template schemas to @template_schemas" do
      template_schema = create(:template_schema)
      get :index
      expect(assigns(:template_schemas)).to eq([template_schema])
    end
  end

  describe "GET show" do
    it "assigns the template schema for the given id to @template_schema" do
      get :new
      expect(assigns(:template_schema)).to be_a_new(TemplateSchema)
    end
  end

  describe "GET new" do
    it "assigns an initialized template schema to @template_schema" do
      get :new
      expect(assigns(:template_schema)).to be_a_new(TemplateSchema)
    end
  end

  describe "GET edit" do
    context "when template schema for the given id is mutable" do
      it "assigns it to @template_schema" do
        template_schema = create(:template_schema)
        get :edit, id: template_schema.id
        expect(assigns(:template_schema)).to eq(template_schema)
      end
    end

    context "when template schema for the given id is inmutable" do
      it "forbids the action" do
        template_schema = create(:template_schema, :immutable)
        get :edit, id: template_schema.id
        expect(response.status).to be(403)
      end
    end
  end

  let(:valid_params) { generate(:template_schema_valid_request_params) }
  let(:invalid_params) { generate(:template_schema_invalid_request_params) }

  describe "POST create" do
    context "with valid params" do
      let(:template_schema) { TemplateSchema.last }

      before { post :create, template_schema: valid_params }

      it "creates a template schema with the given params" do
        expect(template_schema.attributes).to include(valid_params)
      end

      it "sets created_by on the created template schema to the current user id" do
        expect(template_schema.created_by.to_i).to eq(controller.current_user_id)
      end

      it "assigns the created template schema to @template_schema" do
        expect(assigns(:template_schema)).to eq(template_schema)
      end
    end

    context "with invalid params" do
      it "doesn't creates a template schema" do
        expect do
          post :create, template_schema: invalid_params
        end.to_not change { TemplateSchema.count }
      end

      it "assigns the invalid template schema to @template_schema" do
        post :create, template_schema: invalid_params
        expect(assigns(:template_schema)).to be_a(TemplateSchema)
      end
    end
  end

  describe "PUT update" do
    context "when template schema for the given id is mutable" do
      let(:template_schema) { create(:template_schema) }

      context "with valid params" do
        before { put :update, id: template_schema.id, template_schema: valid_params }

        it "updates the template schema with the given params" do
          expect(template_schema.reload.attributes).to include(valid_params)
        end

        it "assigns the updated template schema to @template_schema" do
          expect(assigns(:template_schema)).to eq(template_schema)
        end
      end

      context "with invalid params" do
        before { put :update, id: template_schema.id, template_schema: invalid_params }

        it "doesn't updates the template schema" do
          expect(template_schema.reload.attributes).to_not include(invalid_params)
        end
      end
    end

    context "when template schema for the given id is inmutable" do
      it "forbids the action" do
        template_schema = create(:template_schema, :immutable)
        put :update, id: template_schema.id, template_schema: valid_params
        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE destroy" do
    context "when template schema for the given id is mutable" do
      it "destroys the template schema for the given id" do
        template_schema = create(:template_schema)
        delete :destroy, id: template_schema.id
        expect(template_schema.reload).to be_destroyed
      end
    end

    context "when template schema for the given id is inmutable" do
      it "forbids the action" do
        template_schema = create(:template_schema, :immutable)
        put :destroy, id: template_schema.id
        expect(response.status).to eq(403)
      end
    end
  end
end
