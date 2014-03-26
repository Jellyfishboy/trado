class RefactorTaxRates < ActiveRecord::Migration
  def change
    drop_table :country_taxes
    add_column :countries, :tax_rate_id, :integer
  end
end
