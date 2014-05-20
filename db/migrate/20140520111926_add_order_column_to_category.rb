class AddOrderColumnToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :order, :integer, :default => 0
  end
end
