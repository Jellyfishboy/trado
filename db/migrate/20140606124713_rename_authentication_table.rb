class RenameAuthenticationTable < ActiveRecord::Migration
  def change
    rename_table :authentications, :permissions
  end
end
