class AddDimensionIdToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :dimension_id, :integer
  end
end
