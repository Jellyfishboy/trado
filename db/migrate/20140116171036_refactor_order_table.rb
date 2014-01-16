class RefactorOrderTable < ActiveRecord::Migration
  def change
    remove_column :orders, :billing_first_name
    remove_column :orders, :billing_last_name
    remove_column :orders, :billing_company
    remove_column :orders, :billing_address
    remove_column :orders, :billing_city
    remove_column :orders, :billing_county
    remove_column :orders, :billing_postcode
    remove_column :orders, :billing_country
    remove_column :orders, :billing_telephone
    remove_column :orders, :shipping_first_name
    remove_column :orders, :shipping_last_name
    remove_column :orders, :shipping_company
    remove_column :orders, :shipping_address
    remove_column :orders, :shipping_city
    remove_column :orders, :shipping_county
    remove_column :orders, :shipping_postcode
    remove_column :orders, :shipping_country
    remove_column :orders, :shipping_telephone
    remove_column :orders, :shipping_cost
    remove_column :orders, :invoice_id
    remove_column :orders, :shipping_name
    add_column :orders, :ip_address, :string
    add_column :orders, :user_id, :integer
    add_column :orders, :bill_address_id, :integer
    add_column :orders, :ship_address_id, :integer
  end
end
