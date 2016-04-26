class RemovePaypalAttributes < ActiveRecord::Migration
    def change
        remove_column :store_settings, :paypal_currency_code, :string
        remove_column :transactions, :paypal_id, :string
    end
end
