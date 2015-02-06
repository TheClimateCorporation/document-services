class CreateTemplateSchemas < ActiveRecord::Migration
  def change
    create_table :template_schemas do |t|
      t.string :name, null: false
      t.string :schema_json, null: false
      t.string :json_stub, null: false
      t.boolean :enabled, null: false
      t.string :created_by, null: false

      t.timestamps
    end
  end
end
