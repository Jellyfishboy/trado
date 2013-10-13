class UpdatePriceColumnWithPrecision2ToDecimal < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, :precision => 2
    change_column :line_items, :price, :decimal, :precision => 2
    change_column :accessories, :price, :decimal, :precision => 2
  end
end
