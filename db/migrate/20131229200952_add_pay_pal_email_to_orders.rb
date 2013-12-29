class AddPayPalEmailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paypal_email, :string
  end
end
