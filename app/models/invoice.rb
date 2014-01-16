class Invoice < ActiveRecord::Base
  attr_accessible :billing_address, :date, :delivery_address, :discount_value, 
  :discount_type, :email, :first_name, :invoice_number, :last_name, :notes, :order_id, 
  :pay_type, :shipping_cost, :shipping_method, :order_id, :telephone, :vat_applicable, :vat_number 
  validates :billing_address, :delivery_address, :discount_value, :email, :first_name, :invoice_number, :last_name, :pay_type, :shipping_cost, :shipping_method, :presence => true
  validates :shipping_cost, :discount_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :invoice_number, :telephone, :vat_number, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  has_one :order
end
