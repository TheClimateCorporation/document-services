class CreateGenerationMetadata < ActiveRecord::Migration
  def change
    create_table :generation_metadata do |t|
      t.integer :template_id, null: false
      t.string :version_specified, null: false
      t.integer :version_used, null: false
      t.string :request_id, null: false
      t.string :created_by, null: false
      t.string :document_owner
      t.string :document_id, null: false

      t.timestamps
    end
  end
end
