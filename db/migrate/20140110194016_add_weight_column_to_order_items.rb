class AddWeightColumnToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :weight, :decimal,     :precision => 8, :scale => 2
  end
end
