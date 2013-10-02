class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :first_name
      t.string :last_name
      t.text :billing_address
      t.text :delivery_address
      t.string :email
      t.datetime :date
      t.integer :invoice_number
      t.integer :order_number
      t.text :notes
      t.decimal :discount_amount
      t.string :pay_type
      t.string :discount_type
      t.decimal :shipping

      t.timestamps
    end
  end
end
