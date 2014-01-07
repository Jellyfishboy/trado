class CompleteRefactorOfProductStructure < ActiveRecord::Migration
  def change
    drop_table :dimensions
    rename_table :variant_types, :attribute_types
    rename_table :variant_values, :attribute_values
    add_column :skus, :product_id, :integer
    add_column :skus, :length, :decimal,       :precision => 8, :scale => 2
    add_column :skus, :weight, :decimal,       :precision => 8, :scale => 2
    add_column :skus, :thickness, :decimal,       :precision => 8, :scale => 2
  end
end
