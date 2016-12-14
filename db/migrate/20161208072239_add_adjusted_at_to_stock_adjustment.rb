class AddAdjustedAtToStockAdjustment < ActiveRecord::Migration
  def change
    add_column :stock_adjustments, :adjusted_at, :datetime
  end
end
