class AddTrackingUrlAttributeToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :tracking_url, :string
  end
end
