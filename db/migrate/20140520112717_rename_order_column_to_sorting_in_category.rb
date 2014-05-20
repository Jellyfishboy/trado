class RenameOrderColumnToSortingInCategory < ActiveRecord::Migration
  def change
    rename_column :categories, :order, :sorting
  end
end
