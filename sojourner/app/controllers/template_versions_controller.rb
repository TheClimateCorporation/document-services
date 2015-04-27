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
class TemplateVersionsController < UiController
  before_action :load_template

  # GET /templates/:template_id/v/new
  def new
    @template_version = @template.versions.build
    render_version_view(:new)
  end

  # POST /templates/:template_id/v
  def create
    @template_version = @template.versions.build(template_version_params)
    @template_version.created_by = current_user_id

    respond_to do |format|
      if @template_version.save
        format.html { redirect_to template_path(@template), notice: 'Template version was successfully created.' }
      else
        format.html { render_version_view(:new) }
      end
    end
  end

  # GET /templates/:template_id/v/:version
  def show
    @template_version = @template.version(params[:version])

    render_version_view(:show)
  end

  private

  def load_template
    @template = Template.find(params[:template_id])
  end

  def template_version_params
    whitelist = params.require(:template_version)

    if template_version_type == :template_single_version
      whitelist.permit(:template_schema_id, :file)
    end
  end

  def render_version_view(view = :show)
    load_schemas if view == :new
    render "#{template_version_type.to_s.pluralize}/#{view.to_s}"
  end

  def load_schemas
    if template_version_type == :template_single_version
      @template_schemas = TemplateSchema.all
    end
  end

  def template_version_type
    "#{@template.class.name.underscore}_version".to_sym
  end
end
