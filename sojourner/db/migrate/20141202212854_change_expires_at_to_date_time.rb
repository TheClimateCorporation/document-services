class ChangeExpiresAtToDateTime < ActiveRecord::Migration
  def change
    change_column :users, :expires_at, :datetime
  end
end
