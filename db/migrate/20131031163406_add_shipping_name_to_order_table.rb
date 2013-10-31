class AddShippingNameToOrderTable < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_name, :string
  end
end
