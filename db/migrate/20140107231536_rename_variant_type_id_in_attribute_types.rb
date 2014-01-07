class RenameVariantTypeIdInAttributeTypes < ActiveRecord::Migration
  def change
    rename_column :attribute_values, :variant_type_id, :attribute_type_id
  end
end
