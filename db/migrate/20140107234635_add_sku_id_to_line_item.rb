class AddSkuIdToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :sku_id, :integer
  end
end
