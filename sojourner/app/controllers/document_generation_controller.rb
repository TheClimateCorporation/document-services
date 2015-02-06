class DocumentGenerationController < ApplicationController
  swagger_controller :document_generation, "Document generator"

  protect_from_forgery with: :null_session

  before_filter do
    render text: "Not authorized", status: :unauthorized unless current_user_id
  end

  swagger_api :generate do
    summary "Generate a document from a template and store it in docstore"
    param :form, :template_id, :integer, :required, "Template ID"
    param :form, :version_specified, :integer, :optional, "Template version to use"
    param :form, :schema_id, :integer, :required, "Schema ID"
    param :form, :input_data, :string, :required, "JSON serialized input data"
    param :form, :document_name, :string, :required, "Document name"
    param :form, :document_owner_id, :string, :optional, "Document owner ID"
    param :form, :document_owner_type, :string, :optional, "Document owner type"
    param :form, :publisher_key, :string, :optional, "Routing key to publish to the message buss"
    param :form, :as_production, :boolean, :optional, "Determine template version as in prod server"
    response :ok
    response :unprocessable_entity
  end

  def generate
    generation_metadata = GenerationMetadata.new(generation_metadata_params)

    if generation_metadata.save
      queue_docgen(generation_metadata)
      render json: {document_id: generation_metadata.document_id}
    else
      disable_id_reservation(generation_metadata)
      render json: {errors: generation_metadata.errors}, status: :bad_request
    end
  end

  private

  def generation_metadata_params
    params.permit(
      :template_id,
      :version_specified,
      :schema_id,
      :input_data,
      :document_name,
      :document_owner_id,
      :document_owner_type,
      :publisher_key,
      :as_production
    ).merge(
      created_by: current_user_id,
      request_id: request.uuid,
      document_id: docstore_connector.create_id_reservation['document_id']
    )
  end

  def docstore_connector
    @docstore_connector ||= DocstoreConnector.new({
      request_id: request.uuid,
      request_headers: request.headers
    })
  end

  def queue_docgen(gm)
    Delayed::Job.enqueue(DocumentGenerationJob.new(gm.id))
  end

  def disable_id_reservation(gm)
    docstore_connector.disable_id_reservation(gm.document_id)
  end

end
