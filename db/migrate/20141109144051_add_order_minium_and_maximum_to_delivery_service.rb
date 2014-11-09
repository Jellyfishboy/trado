class AddOrderMiniumAndMaximumToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :order_price_minimum, :decimal, default: 0, precision: 8, scale: 2
    add_column :delivery_services, :order_price_maximum, :decimal, precision: 8, scale: 2
  end
end
