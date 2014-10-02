class ChangeVisibleToActiveForPage < ActiveRecord::Migration
  def change
    rename_column :pages, :visible, :active
    change_column :pages, :active, :boolean, default: false
  end
end
