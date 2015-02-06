class AddPublisherKeyToGenerationMetadata < ActiveRecord::Migration
  def change
    add_column :generation_metadata, :publisher_key, :string
  end
end
