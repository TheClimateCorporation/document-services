class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :document_id, null: false
      t.string :created_by, null: false
      t.string :owner_id, null: false
      t.string :owner_type, default: "User", null: false
      t.integer :size_bytes
      t.string :content_hash
      t.string :uri, null: false
      t.string :type, null: false
      t.string :name, null: false
      t.string :mime_type
      t.text :notes

      t.timestamps
    end

    add_index :documents, :document_id, unique: true
    add_index :documents, :created_by
    add_index :documents, :owner_id
  end
end
