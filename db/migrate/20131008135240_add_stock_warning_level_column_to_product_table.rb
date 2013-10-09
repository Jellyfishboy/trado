class AddStockWarningLevelColumnToProductTable < ActiveRecord::Migration
  def change
    add_column :products, :stock_warning_level, :integer
  end
end
