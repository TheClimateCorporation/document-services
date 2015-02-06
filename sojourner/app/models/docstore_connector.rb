class DocstoreConnector

  DOCSTORE_URL = DotProperties.fetch('sojourner.document_storage.url')

  def initialize(opts = {})
    @request_id = opts[:request_id]
    @request_headers = opts[:request_headers]
  end

  def create_id_reservation
    response = connection.post('id_reservations')
    response.body['document_id']
  end

  def store_document(attrs)
    payload = {
      document_attributes: attrs.slice(
        :document_id,
        :owner_id,
        :owner_type,
        :created_by # CHANGE-ME?
      ),
      document_content: Faraday::UploadIO.new(
        attrs[:document],
        attrs[:mime_type],
        attrs[:name]
      )
    }

    connection.post 'documents', payload do |request|
      # TODO: Remove when ready to refuse all non-authenticated traffic
    end
  end

  def disable_id_reservation(document_id)
    connection.put "id_reservations/#{document_id}"
  end

  private
  #TODO: explicitly include authenticationn information? CHANGE-ME
  def connection
    @connection ||= Faraday.new(url: DOCSTORE_URL) do |faraday|
      faraday.request  :multipart
      faraday.request  :json

      faraday.response :raise_error
      faraday.response :json

      faraday.adapter   Faraday.default_adapter
    end.tap do |connection|
      connection.headers['X-Request-Id'] = @request_id if @request_id
      if @request_headers
        # CHANGE-ME
      end
    end
  end
end
