class CreateOrderItemAccessories < ActiveRecord::Migration
  def change
    create_table :order_item_accessories do |t|
      t.integer :order_item_id
      t.decimal :price
      t.integer :quantity
      t.integer :accessory_id

      t.timestamps
    end
  end
end
