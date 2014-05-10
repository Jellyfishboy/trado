class AddAttributesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :net_amount, :decimal, :precision => 8, :scale => 2
    add_column :orders, :gross_amount, :decimal, :precision => 8, :scale => 2
    add_column :orders, :tax_amount, :decimal, :precision => 8, :scale => 2
  end
end
