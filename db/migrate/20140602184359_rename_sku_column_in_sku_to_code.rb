class RenameSkuColumnInSkuToCode < ActiveRecord::Migration
  def change
    rename_column :skus, :sku, :code
  end
end
