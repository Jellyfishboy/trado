class ChangeEstimateCountryIdToNameForCarts < ActiveRecord::Migration
    def up
        change_column :carts, :estimate_country_id, :string
        rename_column :carts, :estimate_country_id, :estimate_country_name
    end

    def down
        change_column :carts, :estimate_country_name, :integer
        rename_column :carts, :estimate_country_name, :estimate_country_id
    end
end
