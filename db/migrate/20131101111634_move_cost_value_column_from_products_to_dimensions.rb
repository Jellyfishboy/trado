class MoveCostValueColumnFromProductsToDimensions < ActiveRecord::Migration
  def change
    remove_column :products, :cost_value
    add_column :dimensions, :cost_value, :decimal, :precision => 8, :scale => 2
  end
end
