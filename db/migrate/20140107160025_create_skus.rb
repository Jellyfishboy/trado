class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :cost_value, :precision => 8, :scale => 2
      t.integer :stock
      t.integer :stock_warning_level
      t.string :sku

      t.timestamps
    end
  end
end
