class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  attr_accessible :address, :email, :name, :pay_type, :ship_date
  validates :name, :address, :email, :pay_type, :presence => true
  validates_each :pay_type do |model, attr, value|

  after_update :send_new_ship_email, :if => :ship_date_changed? && :no_ship_date
  after_update :send_changed_ship_email, :if => :ship_date_changed? && :ship_date_was

  if !PayType.names.include?(value)
    model.errors.add(attr, "Payment type not on the list") 
  end #validates all columms from the paytype db have been collected
end

  def add_line_items_from_cart(cart)
  	Pcart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end

  def no_ship_date
    self.ship_date_was.nil?
  end

  def send_new_ship_email
    Notifier.order_shipped(self).deliver
  end

  def send_changed_ship_email
    Notifier.changed_shipping(self).deliver
  end
end
