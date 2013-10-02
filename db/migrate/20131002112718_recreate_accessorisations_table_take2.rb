class RecreateAccessorisationsTableTake2 < ActiveRecord::Migration
  def change
    drop_table :acessorisations
    create_table :accessorisations do |t|
        t.integer :accessory_id
        t.integer :product_id

        t.timestamps
    end
  end
end
