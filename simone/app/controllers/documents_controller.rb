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
