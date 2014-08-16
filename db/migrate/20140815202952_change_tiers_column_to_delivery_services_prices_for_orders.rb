class ChangeTiersColumnToDeliveryServicesPricesForOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :tiers, :delivery_service_prices
  end
end
