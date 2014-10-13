class AddDefaultToThemeNameAttribute < ActiveRecord::Migration
  def change
    change_column :store_settings, :theme_name, :string, default: 'redlight'
  end
end
