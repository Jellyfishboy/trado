class RemoveTaxRateIdFromCountry < ActiveRecord::Migration
  def change
    remove_column :countries, :tax_rate_id
  end
end
