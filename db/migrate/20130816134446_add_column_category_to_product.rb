class AddColumnCategoryToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :category, :string  
  end

  def self.down
    remove_column :products, :category
  end
end
