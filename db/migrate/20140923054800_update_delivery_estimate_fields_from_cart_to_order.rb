class UpdateDeliveryEstimateFieldsFromCartToOrder < ActiveRecord::Migration
    def up
        add_column :carts, :estimate_delivery_id, :integer
        add_column :carts, :estimate_country_id, :integer
        add_column :carts, :delivery_service_prices, :integer, array: true

        remove_column :orders, :status, :integer
        remove_column :orders, :delivery_service_prices, :integer, array: true
    end

    def down
        remove_column :carts, :estimate_delivery_id, :integer
        remove_column :carts, :estimate_country_id, :integer
        remove_column :carts, :delivery_service_prices, :integer, array: true

        add_column :orders, :status, :integer
        add_column :orders, :delivery_service_prices, :integer, array: true
    end
end
