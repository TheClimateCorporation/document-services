class TemplatePermissionChangesController < UiController

  # POST /templates/:template_id/v/:version_version/permission_changes
  def create
    permission_change = template_version.permission_changes.new(
      ready_for_production: params[:ready_for_production],
      created_by: current_user_id
    )

    if permission_change.save
      redirect_to template_path(params[:template_id]),
        notice: change_notice(permission_change.ready_for_production)
    else
      render json: permission_change.errors, status: :bad_request
    end
  end

  private

  def template_version
    @template_version ||= Template.find(params[:template_id]).version(params[:version_version])
  end

  def change_notice(ready_for_production)
    if ready_for_production #was change to 'true'
      "Template successfully ENABLED for use in production environment"
    else # it was changed to 'false'
      "Template successfully DISABLED for use in production environment"
    end
  end
end
