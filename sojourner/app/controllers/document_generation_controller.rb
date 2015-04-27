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
class DocumentGenerationController < ApplicationController
  protect_from_forgery with: :null_session

  before_filter do
    render text: "Not authorized", status: :unauthorized unless current_user_id
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
