class AddPaymentMethodAttributeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method, :string
  end
end
