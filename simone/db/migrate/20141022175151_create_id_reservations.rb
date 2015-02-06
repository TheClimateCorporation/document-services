class CreateIdReservations < ActiveRecord::Migration
  def change
    create_table :id_reservations do |t|
      t.string :document_id, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :id_reservations, :document_id, unique: true
    add_index :id_reservations, :enabled
  end
end
