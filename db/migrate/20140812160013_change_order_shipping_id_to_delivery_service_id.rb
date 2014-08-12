class ChangeOrderShippingIdToDeliveryServiceId < ActiveRecord::Migration
  def change
    rename_column :orders, :shipping_id, :delivery_service_price_id
    rename_column :destinations, :shipping_id, :delivery_service_price_id
  end
end
