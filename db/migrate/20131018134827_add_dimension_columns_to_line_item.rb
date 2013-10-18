class AddDimensionColumnsToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :weight, :decimal, :precision => 8, :scale => 2
    add_column :line_items, :thickness, :decimal, :precision => 8, :scale => 2
    add_column :line_items, :length, :decimal, :precision => 8, :scale => 2
  end
end
