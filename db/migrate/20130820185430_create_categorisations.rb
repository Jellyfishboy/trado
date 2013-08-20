class CreateCategorisations < ActiveRecord::Migration
  def change
    create_table :categorisations do |t|
      t.references :category
      t.references :product
      t.integer :product_id
      t.integer :category_id

      t.timestamps
    end
    add_index :categorisations, :category_id
    add_index :categorisations, :product_id
  end
end
