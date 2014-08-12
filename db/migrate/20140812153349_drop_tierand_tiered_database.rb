class DropTierandTieredDatabase < ActiveRecord::Migration
  def change
    drop_table :tiers
    drop_table :tiereds
  end
end
