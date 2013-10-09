class RestructureOrdersTable < ActiveRecord::Migration
  def change
    drop_table :orders
    create_table :orders do |t|
        t.string :first_name
        t.string :last_name
        t.string :billing_company
        t.string :billing_address
        t.string :billing_city
        t.string :billing_county
        t.string :billing_postcode
        t.string :billing_country
        t.string :billing_telephone
        t.string :delivery_address
        t.string :delivery_city
        t.string :delivery_county
        t.string :delivery_postcode
        t.string :delivery_country
        t.string :delivery_telephone
        t.string :email
        t.integer :tax_number
        t.decimal :total
        t.decimal :total_vat
        t.decimal :shipping_cost
        t.string :payment_status
        t.string :shipping_status
        t.datetime :shipping_date

        t.timestamps
    end
  end
end
