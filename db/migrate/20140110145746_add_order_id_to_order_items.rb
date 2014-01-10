class AddOrderIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :order_id, :integer
  end
end
