class RemoveShipAndBillAddressIdFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :ship_address_id
    remove_column :orders, :bill_address_id
  end
end
