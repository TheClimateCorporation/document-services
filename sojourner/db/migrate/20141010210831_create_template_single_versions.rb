class CreateTemplateSingleVersions < ActiveRecord::Migration
  def change
    create_table :template_single_versions do |t|
      t.integer :template_id, null: false
      t.integer :version, null: false
      t.integer :template_schema_id, null: false
      t.string :created_by, null: false

      t.timestamps
    end
  end
end
