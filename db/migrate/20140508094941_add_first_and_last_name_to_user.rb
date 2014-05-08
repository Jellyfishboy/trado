class AddFirstAndLastNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, :default => 'Joe'
    add_column :users, :last_name, :string, :default => 'Bloggs'
  end
end
