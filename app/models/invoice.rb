class Invoice < ActiveRecord::Base
  attr_accessible :billing_address, :date, :delivery_address, :discount_value, :discount_type, :email, :first_name, :invoice_number, :last_name, :notes, :order_number, :pay_type, :shipping
end
