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
