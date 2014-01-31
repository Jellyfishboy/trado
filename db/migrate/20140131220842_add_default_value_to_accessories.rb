class AddDefaultValueToAccessories < ActiveRecord::Migration
  def change
    change_column :accessories, :active, :boolean, :default => true
  end
end
