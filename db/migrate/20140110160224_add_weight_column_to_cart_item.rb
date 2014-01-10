class AddWeightColumnToCartItem < ActiveRecord::Migration
  def change
    add_column :cart_items, :weight, :decimal,     :precision => 8, :scale => 2
    change_column :order_items, :price, :decimal,     :precision => 8, :scale => 2
  end
end
