class AddLocaleToStoreSettings < ActiveRecord::Migration
  def change
    add_column :store_settings, :locale, :string, default: 'en'
  end
end
