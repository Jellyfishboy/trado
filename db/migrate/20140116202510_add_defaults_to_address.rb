class AddDefaultsToAddress < ActiveRecord::Migration
  def change
    change_column :addresses, :active, :boolean, :default => true
    change_column :addresses, :default, :boolean, :default => false
  end
end
