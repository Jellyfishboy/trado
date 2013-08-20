class AddColumnsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :weighting, :integer
    add_column :products, :stock, :integer
  end
end
