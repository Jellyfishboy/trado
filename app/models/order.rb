class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  attr_accessible :first_name, :last_name, :billing_company, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :billing_telephone, :delivery_address, :delivery_city, :delivery_county, :delivery_postcode, :delivery_country, :delivery_telephone, :email, :tax_number, :total, :total_vat, :shipping_cost, :payment_status, :shipping_status, :shipping_date, :invoice_id, :actual_shipping_cost, :vat
  validates :first_name, :last_name, :email, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :delivery_address, :delivery_city, :delivery_county, :delivery_postcode, :delivery_country, :presence => true
  validates_format_of :email, :with => /@/
  validates :terms, :acceptance => {:message => "Please accept the Terms & Conditions."}
  # after_update :send_new_ship_email, :if => :shipping_date_changed? && :no_shipping_date
  # after_update :send_changed_ship_email, :if => :shipping_date_changed? && :shipping_date_was

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end

  def calculate_shipping_tier(cart)
      max_length = cart.line_items.map(&:length).max
      max_thickness = cart.line_items.map(&:thickness).max
      total_weight = cart.line_items.map(&:weight).sum
      # FIXME: Possibly quite slow. Alot of repetition here so will revise later
      tier_raffle = []
      tier_raffle << Tier.where('? >= length_start AND ? <= length_end',max_length, max_length).pluck(:id)
      tier_raffle << Tier.where('? >= thickness_start AND ? <= thickness_end', max_thickness, max_thickness).pluck(:id)
      tier_raffle << Tier.where('? >= weight_start AND ? <= weight_end', total_weight, total_weight).pluck(:id)
      return tier_raffle.max
  end

  def uk_vat
    total_vat = total + (total*0.2)
    vat = total_vat - total
  end

  def no_shipping_date
    self.shipping_date_was.nil?
  end

  def send_new_ship_email
    Notifier.order_shipped(self).deliver
  end

  def send_changed_ship_email
    Notifier.changed_shipping(self).deliver
  end
end
