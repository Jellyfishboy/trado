class AddCategoryIdColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category_id, :integer
  end
end
