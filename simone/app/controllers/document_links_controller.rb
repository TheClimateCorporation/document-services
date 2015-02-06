class DocumentLinksController < ApplicationController

  #POST /document_links
  def create
    links_batch = ReadLinksBatch.new(params[:document_ids], current_user_id)
    links = links_batch.authorized_read_links
    log_link_requests(links)

    render json: links, status: :ok
  end

  private

  def log_link_requests(links_collection)
    links_collection.each do |link_info|
      msg = "User #{current_user_id} requested a read link to " \
        "document #{link_info[:document_id]} and the status was #{link_info[:status]}"
      Rails.logger.info("REQUEST_ID: #{request.uuid} " + msg)
    end
  end

end

