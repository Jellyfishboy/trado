class DropShippingTable < ActiveRecord::Migration
  def change
    drop_table :shippings
  end
end
