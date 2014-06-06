class ModifyRoleDatabaseStructure < ActiveRecord::Migration
  def change
    drop_table :roles_users
    remove_column :users, :role
    change_column :roles, :name, :string, :default => 'user'
  end
end
