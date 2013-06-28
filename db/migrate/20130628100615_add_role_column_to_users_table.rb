class AddRoleColumnToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string, :default => 'user'
  end
  def self.down
    remove_column :users, :role
  end
end
