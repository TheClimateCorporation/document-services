class TemplatePermissionChange < ActiveRecord::Base

  belongs_to :template_version, polymorphic: true

end
