class CreateDimensionals < ActiveRecord::Migration
  def change
    create_table :dimensionals do |t|
      t.integer :product_id
      t.integer :dimension_id

      t.timestamps
    end
  end
end
