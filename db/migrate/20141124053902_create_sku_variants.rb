class CreateSkuVariants < ActiveRecord::Migration
  def change
    create_table :sku_variants do |t|
      t.integer :sku_id
      t.integer :variant_type_id
      t.string :name

      t.timestamps
    end
  end
end
