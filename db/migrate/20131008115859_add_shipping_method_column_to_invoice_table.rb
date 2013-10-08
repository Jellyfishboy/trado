class AddShippingMethodColumnToInvoiceTable < ActiveRecord::Migration
  def change
    add_column :invoices, :shipping_method, :string
  end
end
