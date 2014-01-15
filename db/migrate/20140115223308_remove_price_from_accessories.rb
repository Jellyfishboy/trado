class RemovePriceFromAccessories < ActiveRecord::Migration
  def change
    remove_column :accessories, :price
  end
end
