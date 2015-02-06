class ChangeVersionSpecifiedToNullableForGenerationMetadata < ActiveRecord::Migration
  def up
    change_column :generation_metadata, :version_specified, :string, null: true
    execute "UPDATE generation_metadata SET version_specified = NULL WHERE version_specified = 'lastest'"
    change_column :generation_metadata, :version_specified, :integer
  end

  def down
    change_column :generation_metadata, :version_specified, :string
    execute "UPDATE generation_metadata SET version_specified = 'lastest' WHERE version_specified IS NULL"
    change_column :generation_metadata, :version_specified, :string, null: false
  end
end
