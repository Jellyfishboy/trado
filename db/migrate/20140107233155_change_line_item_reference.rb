class ChangeLineItemReference < ActiveRecord::Migration
  def change
    remove_column :line_items, :dimension_id
  end
end
