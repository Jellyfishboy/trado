class ChangeDimensionDecimalPrecision < ActiveRecord::Migration
  def change
    change_column :dimensions, :thickness, :decimal, :precision => 8, :scale => 2
    change_column :dimensions, :length, :decimal, :precision => 8, :scale => 2
    change_column :dimensions, :weight, :decimal, :precision => 8, :scale => 2
  end
end
