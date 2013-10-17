class CreateTiereds < ActiveRecord::Migration
  def change
    create_table :tiereds do |t|
      t.integer :shipping_id
      t.integer :tier_id

      t.timestamps
    end
  end
end
