class CreateTemplateVersionEnvPermissionChanges < ActiveRecord::Migration
  def change
    create_table :template_version_env_permission_changes do |t|
      t.integer :template_version_id, null: false
      t.string :template_version_type, null: false
      t.boolean :ready_for_production, null: false
      t.string :created_by, null: false

      t.timestamps
    end
  end
end
