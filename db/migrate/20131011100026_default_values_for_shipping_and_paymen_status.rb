class DefaultValuesForShippingAndPaymenStatus < ActiveRecord::Migration
  def change
    change_column :orders, :shipping_status, :string, :default => 'Pending'
    change_column :orders, :payment_status, :string, :default => 'Pending'
  end
end
