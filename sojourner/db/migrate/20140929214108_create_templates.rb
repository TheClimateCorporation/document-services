class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :created_by, null: false

      t.timestamps
    end
  end
end
