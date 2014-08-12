class AddActiveFieldToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :active, :boolean, default: true
  end
end
