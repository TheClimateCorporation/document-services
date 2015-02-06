class AddDeletedAtToTemplateSchemas < ActiveRecord::Migration
  def change
    add_column :template_schemas, :deleted_at, :datetime
    add_index :template_schemas, :deleted_at
  end
end
