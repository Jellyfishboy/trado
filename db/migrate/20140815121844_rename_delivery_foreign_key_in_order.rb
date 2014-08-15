class RenameDeliveryForeignKeyInOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :delivery_service_price_id, :delivery_id
  end
end
