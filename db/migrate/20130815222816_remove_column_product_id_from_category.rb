class RemoveColumnProductIdFromCategory < ActiveRecord::Migration
  def self.up
    remove_column :categories, :product_id
  end

  def self.down
    add_column :categories, :product_id, :integer
  end
end
