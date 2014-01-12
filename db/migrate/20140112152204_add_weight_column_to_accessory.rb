class AddWeightColumnToAccessory < ActiveRecord::Migration
  def change
    add_column :accessories, :weight, :decimal,     :precision => 8, :scale => 2
  end
end
