class AddIndexesToUsers < ActiveRecord::Migration
  def change
    add_index :users, :uid
    add_index :users, :email
    add_index :users, [:uid, :provider], unique: true
  end
end
