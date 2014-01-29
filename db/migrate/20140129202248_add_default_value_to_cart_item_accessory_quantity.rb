class AddDefaultValueToCartItemAccessoryQuantity < ActiveRecord::Migration
  def change
    change_column :cart_item_accessories, :quantity, :integer, :default => 1
  end
end
