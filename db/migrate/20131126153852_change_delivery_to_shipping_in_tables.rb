class ChangeDeliveryToShippingInTables < ActiveRecord::Migration
  def change
    rename_column :orders, :delivery_first_name, :shipping_first_name
    rename_column :orders, :delivery_last_name, :shipping_last_name
    rename_column :orders, :delivery_company, :shipping_company
    rename_column :orders, :delivery_address, :shipping_address
    rename_column :orders, :delivery_city, :shipping_city
    rename_column :orders, :delivery_county, :shipping_county
    rename_column :orders, :delivery_postcode, :shipping_postcode
    rename_column :orders, :delivery_country, :shipping_country
    rename_column :orders, :delivery_telephone, :shipping_telephone
  end
end
