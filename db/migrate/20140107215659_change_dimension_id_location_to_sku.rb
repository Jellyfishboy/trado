class ChangeDimensionIdLocationToSku < ActiveRecord::Migration
  def change
    remove_column :variant_values, :dimension_id
    add_column :skus, :dimension_id, :integer
  end
end
