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
DocumentGenerationJob = Struct.new(:generation_metadata_id) do

  def perform
    DocumentProcessor.new(
      generation_metadata: GenerationMetadata.find(generation_metadata_id)
    ).process
  end

  def error(job, exception)
    generation_metadata_id = stored_generation_metadata_id(job)

    msg = "An error occured while processing DocumentGenerationJob " \
      "for GenerationMetadata #{generation_metadata_id}: "
    Rails.logger.error msg + exception.message
  end

  #TODO: add failure hook to notify message bus

  def queue_name
    'docgen'
  end

  def stored_generation_metadata_id(job)
    YAML.load(job.handler).generation_metadata_id
  end
end
