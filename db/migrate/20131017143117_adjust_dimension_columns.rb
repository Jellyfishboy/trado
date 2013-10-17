class AdjustDimensionColumns < ActiveRecord::Migration
  def change
    rename_column :dimensions, :size, :length
    add_column :dimensions, :thickness, :decimal
    change_column :dimensions, :length, :decimal
    change_column :dimensions, :weight, :decimal
  end
end
