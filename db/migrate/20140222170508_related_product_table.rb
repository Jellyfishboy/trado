class RelatedProductTable < ActiveRecord::Migration
  def up
    create_table :related_products, id: false do |t|
      t.integer :product_id
      t.integer :related_id
    end

    add_index(:related_products, [:product_id, :related_id], :unique => true)
    add_index(:related_products, [:related_id, :product_id], :unique => true)
  end

  def down
      remove_index(:related_products, [:related_id, :product_id])
      remove_index(:related_products, [:product_id, :related_id])
      drop_table :related_products
  end
end
