class DocumentsController < ApplicationController

  #POST /documents
  def create
    doc = Document.new(document_parameters)

    if doc.save #which will save the file, and check the reservation
      render json: doc, status: :created
    else
      render json: { errors: doc.errors }, status: :bad_request
    end
  end

  private

  def document_parameters
    {
      file: params[:document_content],
      mime_type: params[:document_content].try(:content_type),
      name: params[:document_content].try(:original_filename),
      type: Document::DEFAULT_TYPE[Rails.env],
      owner_type: 'User',
      owner_id: current_user_id,
      created_by: current_user_id
    }.merge(params.permit(document_attributes: [
      :notes,
      :group,
      :owner_type,
      :owner_id,
      :type,
      :document_id
    ])[:document_attributes] || {})
  end

end
