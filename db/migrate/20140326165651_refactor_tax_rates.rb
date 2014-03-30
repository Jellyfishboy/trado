class RefactorTaxRates < ActiveRecord::Migration
  def change
    add_column :countries, :tax_rate_id, :integer
  end
end
