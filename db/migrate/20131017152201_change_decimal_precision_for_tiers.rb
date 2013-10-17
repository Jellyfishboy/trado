class ChangeDecimalPrecisionForTiers < ActiveRecord::Migration
  def change
    change_column :tiers, :length_start, :decimal, :precision => 8, :scale => 2
    change_column :tiers, :length_end, :decimal, :precision => 8, :scale => 2
    change_column :tiers, :weight_start, :decimal, :precision => 8, :scale => 2
    change_column :tiers, :weight_end, :decimal, :precision => 8, :scale => 2
    change_column :tiers, :thickness_start, :decimal, :precision => 8, :scale => 2
    change_column :tiers, :thickness_end, :decimal, :precision => 8, :scale => 2
  end
end
