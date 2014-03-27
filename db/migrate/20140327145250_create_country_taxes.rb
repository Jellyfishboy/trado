class CreateCountryTaxes < ActiveRecord::Migration
  def change
    create_table :country_taxes do |t|
      t.integer :country_id
      t.integer :tax_rate_id

      t.timestamps
    end
  end
end
