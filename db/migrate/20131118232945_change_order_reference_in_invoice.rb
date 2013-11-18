class ChangeOrderReferenceInInvoice < ActiveRecord::Migration
  def change
    rename_column :invoices, :order_number, :order_id
  end
end
