class RemoveRedundantColumnsFromDimensions < ActiveRecord::Migration
  def change
    remove_column :dimensions, :price
    remove_column :dimensions, :stock
    remove_column :dimensions, :stock_warning_level
    remove_column :dimensions, :cost_value
  end
end
