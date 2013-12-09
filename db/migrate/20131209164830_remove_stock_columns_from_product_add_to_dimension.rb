class RemoveStockColumnsFromProductAddToDimension < ActiveRecord::Migration
  def change
    remove_column :products, :stock
    remove_column :products, :stock_warning_level
    add_column :dimensions, :stock, :integer
    add_column :dimensions, :stock_warning_level, :integer
  end
end
