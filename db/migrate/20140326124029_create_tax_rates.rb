class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.decimal :rate,     :precision => 8, :scale => 2

      t.timestamps
    end
    add_column :countries, :tax_rate_id, :integer
  end
end
