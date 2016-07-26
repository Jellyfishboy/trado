class AddCurrencyAttributesToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :alpha_three_code, :string
    add_column :countries, :currency, :string
    add_column :countries, :transactional, :boolean, default: false
  end
end
