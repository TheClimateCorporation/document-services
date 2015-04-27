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
class S3Location < StorageLocation

  DEFAULT_BUCKET_NAME = DotProperties.fetch('sojourner.default_s3_bucket_name')
  DEFAULT_PREFIX_BASE = "sojourner"

  def self.s3
    @s3 ||= AWS::S3.new
  end

  def file_saved?
    #this will actually make a call and see if an object exists at the key
    s3_object.exists?
  end

  def read_link
    #default expiration from aws-sdk is 1 hour
    @read_link ||= s3_object.url_for(:read).to_s
  end

  def open(&block)
    URI.parse(read_link).open('rb', &block)
  end

  private

  #URI for s3 objects in the format eg:
  # bucket.name.with.dots/sojourner/templates/TemplateSingleVersion_1.docx
  # bucket.name.with.dots/sojourner/input_data/GenerationMetadata_1.json
  def set_uri
    self.uri ||= "#{DEFAULT_BUCKET_NAME}/#{DEFAULT_PREFIX_BASE}/#{storable.key_prefix}/#{key}"
  end

  def bucket_name
    @bucket_name ||= uri.split('/')[0]
  end

  def full_key
    @full_key ||= uri.split('/').slice(1..-1).join('/')
  end

  def short_key
    @short_key ||= uri.split('/')[-1]
  end

  def bucket
    @bucket ||= self.class.s3.buckets[bucket_name]
  end

  #can instantiate a ruby <AWS::S3::S3Object> without the file existing on S3 yet
  def s3_object
    @s3_object ||= bucket.objects[full_key]
  end

  def put!
    s3_object.write(file)
  end
end
