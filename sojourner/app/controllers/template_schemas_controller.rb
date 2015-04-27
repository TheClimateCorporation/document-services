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
class TemplateSchemasController < UiController
  before_action :set_template_schema, only: [:show, :edit, :update, :destroy, :clone]
  before_action :verify_immutability, only: [:edit, :update, :destroy]

  # GET /template_schemas
  def index
    @template_schemas = TemplateSchema.all
  end

  # GET /template_schemas/1
  def show
  end

  # GET /template_schemas/new
  def new
    @template_schema = TemplateSchema.new
  end

  # GET /template_schemas/1/edit
  def edit
  end

  # POST /template_schemas
  def create
    @template_schema = TemplateSchema.new(template_schema_params)

    @template_schema.created_by = current_user_id

    respond_to do |format|
      if @template_schema.save
        format.html { redirect_to template_schema_path(@template_schema), notice: 'Template schema was successfully created.' }
        format.json { render :show, status: :created, location: @template_schema }
      else
        format.html { render :new }
        format.json { render json: @template_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /template_schemas/:id/clone
  def clone
    @template_schema = TemplateSchema.new_clone(@template_schema)
    render :new
  end

  # PATCH/PUT /template_schemas/1
  def update
    respond_to do |format|
      if @template_schema.update(template_schema_params)
        format.html { redirect_to template_schema_path(@template_schema), notice: 'Template schema was successfully updated.' }
        format.json { render :show, status: :ok, location: @template_schema }
      else
        format.html { render :edit }
        format.json { render json: @template_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_schemas/1
  def destroy
    @template_schema.destroy
    respond_to do |format|
      format.html { redirect_to template_schemas_url, notice: 'Template schema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_template_schema
    @template_schema = TemplateSchema.find(params[:id])
  end

  def template_schema_params
    params.require(:template_schema)
          .permit(:name, :json_schema_properties, :json_stub)
  end

  def verify_immutability
    if @template_schema.immutable?
      render text: "A template is already using this schema", status: :forbidden
    end
  end
end
