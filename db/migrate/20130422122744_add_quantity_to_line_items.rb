class AddQuantityToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :quantity, :integer, :default => 1
  end
  def self.down
	remove_column :line_items, :quantity
  end
end
