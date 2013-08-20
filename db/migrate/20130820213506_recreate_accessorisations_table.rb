class RecreateAccessorisationsTable < ActiveRecord::Migration
  def change
    create_table :accessorisations do |t|
      t.integer :accessory_id
      t.integer :product_id

      t.timestamps
    end
  end
end
