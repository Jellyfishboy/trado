class RevertDimensionIdMove < ActiveRecord::Migration
  def change
    remove_column :skus, :dimension_id
    add_column :variant_values, :dimension_id, :integer
  end
end
