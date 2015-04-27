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
class LocalDocument < Document

  DEFAULT_DIRECTORY = File.join(Rails.root, Rails.env.test? ? 'tmp' : 'public', 'documents')

  def file_saved?
    File.exists?(uri)
  end

  def read_link
    "documents/#{document_id}/#{name}#{file_extension}"
  end

  private

  def set_uri
    self.uri ||= File.join(default_directory, document_id,
      "#{name}#{file_extension}")
  end

  def default_directory
    DEFAULT_DIRECTORY
  end

  def put!
    FileUtils.mkdir_p(File.dirname(uri))
    File.open(uri, 'wb') { |dest| dest.write(file.read) }
  end

end
