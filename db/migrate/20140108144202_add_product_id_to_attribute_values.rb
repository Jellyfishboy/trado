class AddProductIdToAttributeValues < ActiveRecord::Migration
  def change
    add_column :attribute_values, :product_id, :integer
  end
end
