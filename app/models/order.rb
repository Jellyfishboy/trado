class Order < ActiveRecord::Base
  attr_accessible :billing_first_name, :billing_last_name, :billing_company, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :billing_telephone, :shipping_first_name, :shipping_last_name, :shipping_company, :shipping_address, :shipping_city, :shipping_county, :shipping_postcode, :shipping_country, :shipping_telephone, :tax_number, :sub_total, :total, :shipping_cost, :payment_status, :shipping_status, :shipping_date, :invoice_id, :actual_shipping_cost, :vat, :shipping_name, :email, :shipping_id, :pay_type_ids
  validates :billing_first_name, :billing_last_name, :email, :billing_address, :billing_city, :billing_postcode, :billing_country, :shipping_first_name, :shipping_last_name, :shipping_address, :shipping_city, :shipping_postcode, :shipping_country, :presence => { :message => 'is required.' }
  validates :shipping_id, :presence => { :message => 'option is required.'}
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_presence_of :pay_types, :message => 'is required.'
  has_many :line_items, :dependent => :delete_all
  belongs_to :invoice
  has_many :payments, :dependent => :destroy
  has_many :pay_types, :through => :payments
  after_create :calculate_shipping
  after_update :send_new_ship_email, :if => :shipping_date_changed? && :no_shipping_date
  after_update :send_changed_ship_email, :if => :shipping_date_changed? && :shipping_date_was

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end

  def display_shippings(calculated_tier)
    @tier = Tier.find(calculated_tier)
    # Default is to display UK shipping options in the specified tier
    return @tier.shippings.joins(:countries).where('country_id = ?', 1)
  end

  def calculate_order(cart)
    self.sub_total = cart.total_price
    self.vat = sub_total*0.2 
    self.total = sub_total + vat
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
      return tier_raffle.max.first
  end

  def calculate_shipping
    @shipping = Shipping.find(self.shipping_id)
    self.shipping_cost = @shipping.price
    self.shipping_name = @shipping.name
    self.save!
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
