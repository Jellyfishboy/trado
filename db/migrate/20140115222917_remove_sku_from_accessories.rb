class RemoveSkuFromAccessories < ActiveRecord::Migration
  def change
    remove_column :accessories, :sku 
  end
end
