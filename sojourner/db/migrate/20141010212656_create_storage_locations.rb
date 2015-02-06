class CreateStorageLocations < ActiveRecord::Migration
  def change
    create_table :storage_locations do |t|
      t.string :type, null: false
      t.string :uri, null: false
      t.integer :storable_id, null: false
      t.string :storable_type, null: false

      t.timestamps
    end
  end
end
