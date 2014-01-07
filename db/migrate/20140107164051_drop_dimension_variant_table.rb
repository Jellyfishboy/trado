class DropDimensionVariantTable < ActiveRecord::Migration
  def change
    drop_table :dimension_variants
  end
end
