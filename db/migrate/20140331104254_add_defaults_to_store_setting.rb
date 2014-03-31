class AddDefaultsToStoreSetting < ActiveRecord::Migration
  def change
    change_column :store_settings, :name, :string, :default => 'Trado'
    change_column :store_settings, :email, :string, :default => 'admin@example.com'
    change_column :store_settings, :tax_name, :string, :default => 'VAT'
    change_column :store_settings, :currency, :string, :default => '£'
  end
end
