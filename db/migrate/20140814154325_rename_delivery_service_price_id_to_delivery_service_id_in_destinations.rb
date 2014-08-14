class RenameDeliveryServicePriceIdToDeliveryServiceIdInDestinations < ActiveRecord::Migration
  def change
    rename_column :destinations, :delivery_service_price_id, :delivery_service_id
  end
end
