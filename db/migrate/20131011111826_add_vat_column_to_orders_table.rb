class AddVatColumnToOrdersTable < ActiveRecord::Migration
  def change
    add_column :orders, :vat, :decimal, :precision => 8, :scale => 2
  end
end
