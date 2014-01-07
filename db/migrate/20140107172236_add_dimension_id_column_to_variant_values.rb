class AddDimensionIdColumnToVariantValues < ActiveRecord::Migration
  def change
    add_column :variant_values, :dimension_id, :integer
  end
end
