class AddColumnsToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :attribute_value, :string
    add_column :line_items, :attribute_type, :string
    add_column :line_items, :attribute_measurement, :string
  end
end
