class ChangeVariantTable < ActiveRecord::Migration
  def change
    rename_table :variants, :variant_types
    rename_column :variant_values, :variant_id, :variant_type_id
  end
end
