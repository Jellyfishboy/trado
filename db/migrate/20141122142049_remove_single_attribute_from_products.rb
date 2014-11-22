class RemoveSingleAttributeFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :single
  end
end
