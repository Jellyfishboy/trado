class RenameAttributeTypeToVariantType < ActiveRecord::Migration
  def change
    rename_table :attribute_types, :variant_types
  end
end
