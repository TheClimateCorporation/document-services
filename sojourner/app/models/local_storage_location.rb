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
class LocalStorageLocation < StorageLocation

  def file_saved?
    File.exists?(uri)
  end

  def read_link
    @read_link ||= "/#{storable.key_prefix}/#{key}"
  end

  def open(&block)
    File.open(uri, 'rb', &block)
  end

  private

  def set_uri
    self.uri ||= "#{storable_directory}/#{key}"
  end

  def storable_directory
    dir = File.join(Rails.root, Rails.env.test? ? 'tmp' : 'public', storable.key_prefix)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    dir
  end

  def put!
    File.open(uri, 'wb') { |dest| dest.write(file.read) }
  end

end
