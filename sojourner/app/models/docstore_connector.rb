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
class DocstoreConnector

  DOCSTORE_URL = DotProperties.fetch('sojourner.document_storage.url')

  def initialize(opts = {})
    @request_id = opts[:request_id]
    @request_headers = opts[:request_headers]
  end

  def create_id_reservation
    response = connection.post('id_reservations')
    response.body.slice('document_id', 'enabled')
  end

  def disable_id_reservation(document_id)
    response = connection.put "id_reservations/#{document_id}"
    response.body.slice('document_id', 'enabled')
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
