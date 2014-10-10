class AddPageTitleToProduct < ActiveRecord::Migration
  def change
    add_column :products, :page_title, :string
  end
end
