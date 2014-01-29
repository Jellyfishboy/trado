class AddColumnsToAccessories < ActiveRecord::Migration
  def change
    add_column :accessories, :price, :decimal
    add_column :accessories, :weight, :decimal
    add_column :accessories, :cost_value, :decimal
    add_column :accessories, :active, :boolean
  end
end
