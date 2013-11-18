class Invoice < ActiveRecord::Base
  attr_accessible :billing_address, :date, :delivery_address, :discount_value, :discount_type, :email, :first_name, :invoice_number, :last_name, :notes, :order_id, :pay_type, :shipping_cost, :shipping_method, :order_id
  validates :billing_address, :delivery_address, :discount_value, :email, :first_name, :invoice_number, :last_name, :notes, :pay_type, :shipping_cost, :shipping_method, :presence => true
  validates :shipping_cost, :discount_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }, :numericality => { :greater_than_or_equal_to => 0.1 }
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :invoice_number, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  has_one :order
end
