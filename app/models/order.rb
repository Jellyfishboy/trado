# Order Documentation
#
# The order table handles all the data associated to a current, completed or failed order. 
# It is updated throughout the order process and discarded if the order is not completed within 2 days. 
# Each order has an associated transaction which contains more information on the payment process. 

# == Schema Information
#
# Table name: orders
#
#  id                       :integer          not null, primary key
#  ip_address               :string(255)      
#  email                    :string(255)     
#  status                   :string(255)          
#  user_id                  :integer     
#  bill_address_id          :integer     
#  ship_address_id          :integer     
#  tax_number               :integer 
#  shipping_id              :integer        
#  shipping_status          :string(255)      default("Pending")   
#  shipping_date            :datetime 
#  actual_shipping_cost     :decimal          precision(8), scale(2) 
#  express_token            :string(255) 
#  express_payer_id         :string(255) 
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Order < ActiveRecord::Base
  attr_accessible :tax_number, :shipping_status, :shipping_date, :actual_shipping_cost, 
  :email, :shipping_id, :status, :ip_address, :user_id, :bill_address_id, :ship_address_id, :express_token, :express_payer_id
  
  has_many :order_items,                                                :dependent => :delete_all
  has_one :transaction,                                                 :dependent => :destroy

  belongs_to :shipping
  belongs_to :ship_address,                                             class_name: 'Address'
  belongs_to :bill_address,                                             class_name: 'Address'

  validates :email,                                                     :presence => { :message => 'is required' }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :if => :active_or_shipping?
  validates :shipping_id,                                               :presence => { :message => 'Shipping option is required'}, :if => :active_or_shipping?                                                                                                                  

  after_update :delayed_shipping, :ship_order_today,                    :if => :shipping_date_nil?

  # Upon completing an order, transfer the cart item data to new order item records 
  #
  # @return [nil]
  def add_cart_items_from_cart(cart)
  	cart.cart_items.each do |item|
      @order_item = order_items.build(:price => item.price, :quantity => item.quantity, :sku_id => item.sku_id, :weight => item.weight, :order_id => self.id)
      @order_item.build_order_item_accessory(:accessory_id => item.cart_item_accessory.accessory_id, :price => item.cart_item_accessory.price, :quantity => item.cart_item_accessory.quantity) unless item.cart_item_accessory.nil?
      @order_item.save!
  	end
  end

  # Set the session variables for an order - sub total, tax and total
  #
  # @return [session]
  # FIXME: Looks really ugly and clumsy. Fix when internationalized tax is introduced.
  def calculate_order(cart, session, current_tax_rate)
    session[:sub_total] = session[:tax] = session[:total] = nil
    session[:sub_total] = cart.total_price + self.shipping.price
    session[:tax] = (session[:sub_total]*current_tax_rate) + (self.shipping.price*current_tax_rate)
    session[:total] = session[:sub_total]+session[:tax]+self.shipping.price
  end

  # Calculate the relevant shipping tier for an order, taking into account length, thickness and weight of the total order
  #
  # @return [object]
  def calculate_shipping_tier(cart)
      max_length = cart.skus.map(&:length).max
      max_thickness = cart.skus.map(&:thickness).max
      total_weight = cart.cart_items.map(&:weight).sum
      # FIXME: Possibly quite slow. Alot of repetition here so will revise later
      tier_raffle = []
      tier_raffle << Tier.where('? >= length_start AND ? <= length_end',max_length, max_length).pluck(:id)
      tier_raffle << Tier.where('? >= thickness_start AND ? <= thickness_end', max_thickness, max_thickness).pluck(:id)
      tier_raffle << Tier.where('? >= weight_start AND ? <= weight_end', total_weight, total_weight).pluck(:id)
      return tier_raffle.max.first
  end

  # If you set the shipping date for an order more than once, send a delayed shipping email
  #
  # @return [array]
  def delayed_shipping
    if self.shipping_date_changed? && self.shipping_date_was
      Notifier.shipping_delayed(self).deliver
    end
  end

  # When shipping date for an order is set, if it's today, mark the order as dispatched and send the relevant email
  #
  # @return [nil]
  def ship_order_today
    if self.shipping_date.to_date == Date.today
      self.update_column(:shipping_status, "Dispatched")
      Notifier.order_shipped(self).deliver
    end
  end

  # Determines whether the shipping date of the current order is nil
  #
  # @return [boolean]
  def shipping_date_nil?
    return true unless self.shipping_date.nil?
  end

  # Detects if the current status of the order is 'active'. Inactive orders are deleted on a daily cron job
  #
  # @return [boolean]
  def active?
    status == 'active'
  end

  # Detects if the current status of the order is 'billing'. See wicked gem for more info
  #
  # @return [boolean]
  def active_or_billing?
    status == 'billing' ? true : active?
  end

  # Detects if the current status of the order is 'shipping'. See wicked gem for more info
  #
  # @return [boolean]
  def active_or_shipping?
    status == 'shipping' ? true : active?
  end

  # Detects if the current status of the order is 'payment'. See wicked gem for more info
  #
  # @return [boolean]
  def active_or_payment?
    status == 'payment' ? true : active?
  end

end
