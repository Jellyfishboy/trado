class ChangeTotalColumnNamesInOrderTable < ActiveRecord::Migration
  def change
    rename_column :orders, :total, :sub_total
    rename_column :orders, :total_vat, :total
  end
end
