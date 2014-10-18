class AddThemeNameAttributeToStoreSetting < ActiveRecord::Migration
  def change
    add_column :store_settings, :theme_name, :string
  end
end
