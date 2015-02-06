class CreateSampleDocuments < ActiveRecord::Migration
  def change
    create_table :sample_documents do |t|
      t.integer :template_version_id, null: false
      t.string :template_version_type, null: false
      t.string :document_id, null: false

      t.timestamps
    end
  end
end
