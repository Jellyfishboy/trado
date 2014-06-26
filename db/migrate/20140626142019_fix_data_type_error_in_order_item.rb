class FixDataTypeErrorInOrderItem < ActiveRecord::Migration
  def change
    change_column :order_items, :sku_id, :integer
  end
end
