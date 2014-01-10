class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal :price
      t.integer :quantity
      t.string :sku_id

      t.timestamps
    end
  end
end
