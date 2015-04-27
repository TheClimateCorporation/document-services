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
class TemplatesController < UiController
  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/:id
  def show
    @template = Template.find(params[:id])
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # POST /templates
  def create
    @template = Template.new(template_params)
    @template.type = 'TemplateSingle' # Only template type available at this moment
    @template.created_by = current_user_id

    respond_to do |format|
      if @template.save
        format.html { redirect_to template_path(@template), notice: 'Template was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def template_params
    params.require(:template).permit(:name)
  end
end
