class RemoveDimensionIdFromAttributeValues < ActiveRecord::Migration
  def change
    remove_column :attribute_values, :dimension_id
  end
end
