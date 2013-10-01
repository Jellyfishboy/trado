class AddPartNumberAndSkuColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :part_number, :integer
    add_column :products, :sku, :string
  end
end
