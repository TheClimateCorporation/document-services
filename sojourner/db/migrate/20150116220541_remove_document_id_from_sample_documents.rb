class RemoveDocumentIdFromSampleDocuments < ActiveRecord::Migration
  def up
    remove_column :sample_documents, :document_id
  end

  def down
    add_column :sample_documents, :document_id, null: false
  end
end
