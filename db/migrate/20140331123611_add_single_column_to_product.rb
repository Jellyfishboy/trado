class AddSingleColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :single, :boolean
  end
end
