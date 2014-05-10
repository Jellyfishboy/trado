class AddAttributesToStoreSettings < ActiveRecord::Migration
  def change
    add_column :store_settings, :cheque, :boolean, :default => false
    add_column :store_settings, :bank_transfer, :boolean, :default => false
  end
end
