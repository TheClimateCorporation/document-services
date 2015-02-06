class AddIndexesForInitialDataModelAssociations < ActiveRecord::Migration
  def change
    add_index :sample_documents, :template_version_id
    add_index :storage_locations, :storable_id
    add_index :template_single_versions, :template_schema_id
    add_index :template_single_versions, :template_id
    add_index :template_single_versions, [:template_id, :version], unique: true
  end
end
