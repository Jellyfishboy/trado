class CreateStockLevels < ActiveRecord::Migration
  def change
    create_table :stock_levels do |t|
      t.string :description
      t.integer :adjustment, :default => 0
      t.integer :sku_id

      t.timestamps
    end
  end
end
