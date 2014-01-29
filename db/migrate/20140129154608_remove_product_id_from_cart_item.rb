class RemoveProductIdFromCartItem < ActiveRecord::Migration
  def change
    remove_column :cart_items, :product_id, :integer
  end
end
