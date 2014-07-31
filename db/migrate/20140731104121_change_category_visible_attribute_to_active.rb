class ChangeCategoryVisibleAttributeToActive < ActiveRecord::Migration
  def change
    rename_column :categories, :visible, :active
  end
end
