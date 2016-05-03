class RenameCartAttributes < ActiveRecord::Migration
    def change
        rename_column :carts, :estimate_delivery_id, :delivery_id
        rename_column :carts, :estimate_country_name, :country
    end
end
