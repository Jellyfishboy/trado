class RenameStockLevelTableToStockAdjustment < ActiveRecord::Migration
  def change
    rename_table :stock_levels, :stock_adjustments
  end
end
