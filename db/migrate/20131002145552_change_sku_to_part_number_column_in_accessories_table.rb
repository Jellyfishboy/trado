class ChangeSkuToPartNumberColumnInAccessoriesTable < ActiveRecord::Migration
  def change
    rename_column :accessories, :sku, :part_number
  end
end
