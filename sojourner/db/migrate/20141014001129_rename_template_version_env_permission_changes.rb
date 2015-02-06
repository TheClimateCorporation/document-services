class RenameTemplateVersionEnvPermissionChanges < ActiveRecord::Migration
  def change
    rename_table :template_version_env_permission_changes, :template_permission_changes
  end
end
