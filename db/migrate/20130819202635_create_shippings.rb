class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
      t.references :weight
      t.references :dimension
      t.integer :dimension_id
      t.string :name
      t.text :description
      t.integer :price
      t.boolean :insurance

      t.timestamps
    end
    add_index :shippings, :dimension_id
  end
end
