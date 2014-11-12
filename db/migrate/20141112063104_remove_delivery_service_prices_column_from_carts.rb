class RemoveDeliveryServicePricesColumnFromCarts < ActiveRecord::Migration
  def change
    remove_column :carts, :delivery_service_prices
  end
end
