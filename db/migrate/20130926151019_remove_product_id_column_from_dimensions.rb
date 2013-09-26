class RemoveProductIdColumnFromDimensions < ActiveRecord::Migration
  def up
    remove_column :dimensions, :product_id
  end

  def down
    add_column :dimensions, :product_id
  end
end
