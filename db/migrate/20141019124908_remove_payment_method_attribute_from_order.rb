class RemovePaymentMethodAttributeFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :payment_method
  end
end
