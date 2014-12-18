class DropTaxNumberColumnFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :tax_number
  end
end
