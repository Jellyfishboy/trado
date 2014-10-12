class AddMenuTitleToPages < ActiveRecord::Migration
  def change
    add_column :pages, :menu_title, :string
  end
end
