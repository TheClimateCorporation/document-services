class RenameUserExpiresToExpiresAt < ActiveRecord::Migration
  def change
    rename_column :users, :expires, :expires_at
  end
end
