class RemoveEnabledFromTemplateSchemas < ActiveRecord::Migration
  def change
    remove_column :template_schemas, :enabled, :boolean
  end
end
