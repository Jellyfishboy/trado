class AddTierColumnToOrderTable < ActiveRecord::Migration
  def change
  	add_column :orders, :tier, :integer
  end
end
