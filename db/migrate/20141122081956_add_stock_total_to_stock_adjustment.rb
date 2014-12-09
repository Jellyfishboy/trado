class AddStockTotalToStockAdjustment < ActiveRecord::Migration
  def change
    add_column :stock_adjustments, :stock_total, :integer
    change_column :stock_adjustments, :adjustment, :integer, default: 1
  end
end
