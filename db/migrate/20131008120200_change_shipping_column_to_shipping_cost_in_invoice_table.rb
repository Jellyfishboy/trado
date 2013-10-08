class ChangeShippingColumnToShippingCostInInvoiceTable < ActiveRecord::Migration
  def change
    rename_column :invoices, :shipping, :shipping_cost
  end
end
