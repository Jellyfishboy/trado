class AddOrderIdToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :order_id, :integer
  end
end
