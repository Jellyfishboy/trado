class CreateCartItemAccessories < ActiveRecord::Migration
  def change
    create_table :cart_item_accessories do |t|
      t.integer :cart_item_id
      t.decimal :price,     :precision => 8, :scale => 2
      t.integer :quantity
      t.integer :accessory_id
      t.decimal :weight,     :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
