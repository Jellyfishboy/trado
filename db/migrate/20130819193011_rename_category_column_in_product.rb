class RenameCategoryColumnInProduct < ActiveRecord::Migration
  def change
    rename_column :products, :category, :category_id
    change_column :products, :category_id, :integer
  end
end
