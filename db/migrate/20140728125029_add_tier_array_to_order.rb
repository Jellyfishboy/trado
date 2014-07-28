class AddTierArrayToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :tiers, :integer, array: true
  end
end
