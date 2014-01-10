class AmendStructureOfLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :product_id
    remove_column :line_items, :weight
    remove_column :line_items, :thickness
    remove_column :line_items, :length
    remove_column :line_items, :sku
    remove_column :line_items, :attribute_value
    remove_column :line_items, :attribute_type
    remove_column :line_items, :attribute_measurement
    rename_table :line_items, :cart_items
  end
end
