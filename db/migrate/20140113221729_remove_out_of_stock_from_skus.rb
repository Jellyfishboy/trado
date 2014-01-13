class RemoveOutOfStockFromSkus < ActiveRecord::Migration
  def change
    remove_column :skus, :out_of_stock
  end
end
