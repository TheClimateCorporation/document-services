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
class SampleDocumentsController < UiController

  # POST /templates/:template_id/v/:version_version/sample_document
  def create
    sample_doc = SampleDocument.generate_new_sample(template_version)

    if sample_doc.save
      redirect_to template_version_path(params[:template_id], params[:version_version])
    else
      redirect_to template_version_path(params[:template_id],
                          params[:version_version]), alert: sample_doc.errors.messages
    end
  end

  private

  def template_version
    @template_version ||= Template.find(params[:template_id]).version(params[:version_version])
  end

end
