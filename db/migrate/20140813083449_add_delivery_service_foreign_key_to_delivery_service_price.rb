class AddDeliveryServiceForeignKeyToDeliveryServicePrice < ActiveRecord::Migration
  def change
    add_column :delivery_service_prices, :delivery_service_id, :integer
  end
end
