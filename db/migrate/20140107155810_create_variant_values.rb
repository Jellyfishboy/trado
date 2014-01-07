class CreateVariantValues < ActiveRecord::Migration
  def change
    create_table :variant_values do |t|
      t.integer :variant_id
      t.integer :sku_id
      t.string :value

      t.timestamps
    end
  end
end
