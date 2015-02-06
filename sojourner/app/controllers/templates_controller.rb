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
