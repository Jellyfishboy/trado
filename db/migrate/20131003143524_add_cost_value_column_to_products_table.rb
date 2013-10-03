class AddCostValueColumnToProductsTable < ActiveRecord::Migration
  def change
    add_column :products, :cost_value, :decimal
  end
end
