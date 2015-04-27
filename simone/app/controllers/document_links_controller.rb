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

