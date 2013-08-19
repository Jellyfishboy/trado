class RemoveCategoryIdColumnFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :category_id
    add_column :products, :category_id, :integer
  end
end
