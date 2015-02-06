class AddIndexToTemplatePermissionChanges < ActiveRecord::Migration
  def change
      add_index :template_permission_changes, :template_version_id
  end
end
