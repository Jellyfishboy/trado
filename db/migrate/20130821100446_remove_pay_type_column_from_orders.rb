class RemovePayTypeColumnFromOrders < ActiveRecord::Migration
  def change
    drop_table :pay_types
    remove_column :orders, :pay_type
  end
end
