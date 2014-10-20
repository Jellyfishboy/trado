class AddPaypalCurrencyCodeToStoreSetting < ActiveRecord::Migration
  def change
    add_column :store_settings, :paypal_currency_code, :string, default: 'GBP'
  end
end
