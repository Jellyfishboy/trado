class AddFieldToStoreSettings < ActiveRecord::Migration
  def change
    add_column :store_settings, :tax_breakdown, :boolean, :default => false
  end
end
