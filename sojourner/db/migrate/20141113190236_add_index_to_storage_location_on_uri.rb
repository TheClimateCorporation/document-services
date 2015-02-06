class AddIndexToStorageLocationOnUri < ActiveRecord::Migration
  def change
    add_index :storage_locations, :uri, unique: true
  end
end
