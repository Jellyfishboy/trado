class AddSlugAttributeToPage < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string
  end
end
