class RemovePaypalPluginAttributes < ActiveRecord::Migration
  def change
    remove_column :store_settings, :paypal_currency_code
    remove_column :transactions, :paypal_id
    remove_column :orders, :paypal_express_token
    remove_column :orders, :paypal_express_payer_id
  end
end
