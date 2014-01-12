class AddSlugToProduct < ActiveRecord::Migration
  def change
    add_column :products, :slug, :string
    add_column :categories, :slug, :string
  end
end
