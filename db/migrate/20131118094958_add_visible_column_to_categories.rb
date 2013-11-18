class AddVisibleColumnToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :visible, :boolean, :default => false
  end
end
