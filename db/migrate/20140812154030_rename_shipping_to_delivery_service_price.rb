class RenameShippingToDeliveryServicePrice < ActiveRecord::Migration
  def change
    rename_table :shippings, :delivery_service_prices
    rename_column :delivery_service_prices, :name, :code
    add_column :delivery_service_prices, :min_weight, :decimal, precision: 8, scale: 2
    add_column :delivery_service_prices, :max_weight, :decimal, precision: 8, scale: 2
    add_column :delivery_service_prices, :min_length, :decimal, precision: 8, scale: 2
    add_column :delivery_service_prices, :max_length, :decimal, precision: 8, scale: 2
    add_column :delivery_service_prices, :min_thickness, :decimal, precision: 8, scale: 2
    add_column :delivery_service_prices, :max_thickness, :decimal, precision: 8, scale: 2
  end
end
