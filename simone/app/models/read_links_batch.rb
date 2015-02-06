class ReadLinksBatch
  attr_reader :read_links, # hash doc-id => link, doc_id => link
              :document_ids,
              :user_id

  def initialize(document_ids, user_id)
    @user_id = user_id
    @document_ids = document_ids

    @read_links = []
  end

  def authorized_read_links
    @docs = Document.where(document_id: @document_ids).order(:document_id)
    not_found_ids = document_ids - @docs.map(&:document_id)

    not_found_ids.map { |id| not_found_info(id) }
    @docs.map { |doc| link_info(doc) }

    read_links
  end

  def to_json(options = {})
    read_links.to_json
  end

  private

  def link_info(document)
    info = { document_id: document.document_id }.with_indifferent_access

    if DocumentAuthorizor.authorized?(document, @user_id)
      info[:read_link] = document.read_link.to_s
      info[:status] = :success
    else
      info[:error] = "User #{@user_id} not authorized to read document #{document.document_id}"
      info[:status] = :unauthorized
    end

    @read_links << info
  end

  def not_found_info(not_found_id)
    info = {
      document_id: not_found_id,
      error: "No document found for document_id: #{not_found_id}",
      status: :not_found
    }.with_indifferent_access

    @read_links << info
  end
end
