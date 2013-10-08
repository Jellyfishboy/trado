class AddInvoiceIdAndActualShippingMethodColumnsToOrderTable < ActiveRecord::Migration
  def change
    add_column :orders, :invoice_id, :integer
    add_column :orders, :actual_shipping_cost, :decimal
  end
end
