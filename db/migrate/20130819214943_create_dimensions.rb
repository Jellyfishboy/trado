class CreateDimensions < ActiveRecord::Migration
  def change
    create_table :dimensions do |t|
      t.integer :product_id
      t.integer :weight
      t.integer :size

      t.timestamps
    end
  end
end
