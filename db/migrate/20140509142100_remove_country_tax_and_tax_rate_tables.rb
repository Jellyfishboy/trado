class RemoveCountryTaxAndTaxRateTables < ActiveRecord::Migration
  def change
    drop_table :country_taxes
    drop_table :tax_rates
  end
end
