class AddDocumentOwnerTypeToGenerationMetadata < ActiveRecord::Migration
  def change
    rename_column :generation_metadata, :document_owner, :document_owner_id
    add_column :generation_metadata, :document_owner_type, :string, default: "user", null: false
  end
end
