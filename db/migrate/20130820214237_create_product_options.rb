class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
