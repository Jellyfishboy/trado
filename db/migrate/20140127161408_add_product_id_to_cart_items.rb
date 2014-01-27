class AddProductIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :product_id, :integer
    remove_column :cart_items, :order_id
  end
end
