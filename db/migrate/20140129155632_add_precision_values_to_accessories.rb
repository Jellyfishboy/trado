class AddPrecisionValuesToAccessories < ActiveRecord::Migration
  def change
    change_column :accessories, :price, :decimal,     :precision => 8, :scale => 2
    change_column :accessories, :cost_value, :decimal,     :precision => 8, :scale => 2
    change_column :accessories, :weight, :decimal,     :precision => 8, :scale => 2
  end
end
