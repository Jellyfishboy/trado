class AddSkuAttributeToLineItemTable < ActiveRecord::Migration
  def change
  	add_column :line_items, :sku, :string
  end
end
