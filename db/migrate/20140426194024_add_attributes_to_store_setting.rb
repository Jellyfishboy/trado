class AddAttributesToStoreSetting < ActiveRecord::Migration
  def change
    add_column :store_settings, :ga_code, :string
    add_column :store_settings, :ga_active, :boolean
  end
end
