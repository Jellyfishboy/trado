class RemoveColumnsFromOrderTable < ActiveRecord::Migration
  def change
    remove_column :orders, :sub_total
    remove_column :orders, :total
    remove_column :orders, :payment_status
    remove_column :orders, :vat
    remove_column :orders, :paypal_email
    remove_column :orders, :purchased_at
  end
end
