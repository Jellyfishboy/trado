class AddActiveColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, :default => true
  end
end
