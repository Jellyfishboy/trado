class AddDefaultValuesToStoreSetting < ActiveRecord::Migration
  def change
    change_column :store_settings, :ga_active, :boolean, :default => false
    change_column :store_settings, :ga_code, :string, :default => 'UA-XXXXX-X'
  end
end
