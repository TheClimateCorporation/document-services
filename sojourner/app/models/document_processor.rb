class DocumentProcessor
  def initialize(opts = {})
    @generation_metadata = opts.fetch(:generation_metadata)
    @request_headers = opts[:request_headers] #optional
  end

  def process
    template_version = @generation_metadata.fetch_template_version_used
    document = template_version.render(@generation_metadata.input_data)

    DocstoreConnector.new(
      request_id: @generation_metadata.request_id,
      request_headers: @request_headers
    ).store_document(
      created_by: @generation_metadata.created_by,
      document: document,
      document_id: @generation_metadata.document_id,
      mime_type: 'application/pdf',
      name: @generation_metadata.document_name,
      owner_id: @generation_metadata.document_owner_id,
      owner_type: @generation_metadata.document_owner_type
    )

    document.close

    key = @generation_metadata.publisher_key || 'sojourner.document-created'
    MessageBus.publish(key, "protect", { document_id: @generation_metadata.document_id })

    document
  end
end
