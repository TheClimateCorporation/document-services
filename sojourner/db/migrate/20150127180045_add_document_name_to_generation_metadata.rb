class AddDocumentNameToGenerationMetadata < ActiveRecord::Migration
  def change
    add_column :generation_metadata, :document_name, :string, null: false
  end
end
