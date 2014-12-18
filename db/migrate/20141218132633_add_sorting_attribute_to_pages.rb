class AddSortingAttributeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :sorting, :integer, default: 0
  end
end
