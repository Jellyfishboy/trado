class AddPrecisionToAllDecimalDataTypes < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, :precision => 8, :scale => 2
    change_column :line_items, :price, :decimal, :precision => 8, :scale => 2
    change_column :accessories, :price, :decimal, :precision => 8, :scale => 2
    change_column :invoices, :discount_value, :decimal, :precision => 8, :scale => 2
    change_column :invoices, :shipping_cost, :decimal, :precision => 8, :scale => 2
    change_column :orders, :total, :decimal, :precision => 8, :scale => 2
    change_column :orders, :total_vat, :decimal, :precision => 8, :scale => 2
    change_column :orders, :shipping_cost, :decimal, :precision => 8, :scale => 2
    change_column :orders, :actual_shipping_cost, :decimal, :precision => 8, :scale => 2
    change_column :products, :cost_value, :decimal, :precision => 8, :scale => 2
  end
end
