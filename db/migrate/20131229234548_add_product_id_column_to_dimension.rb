class AddProductIdColumnToDimension < ActiveRecord::Migration
  def change
    add_column :dimensions, :product_id, :integer
    
  end
end
