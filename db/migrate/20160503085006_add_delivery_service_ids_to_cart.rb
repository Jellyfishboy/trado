class AddDeliveryServiceIdsToCart < ActiveRecord::Migration
    def change
        add_column :carts, :delivery_service_ids, :text
    end
end
