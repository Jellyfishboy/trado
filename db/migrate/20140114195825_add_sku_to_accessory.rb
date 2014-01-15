class AddSkuToAccessory < ActiveRecord::Migration
  def change
    add_column :accessories, :sku, :string
  end
end
