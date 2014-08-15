# Order Documentation
#
# The order table handles all the data associated to a current, completed or failed order. 
# It is updated throughout the order process and discarded if the order is not completed within 2 days. 
# Each order has an associated transaction which contains more information on the payment process. 

# == Schema Information
#
# Table name: orders
#
#  id                                     :integer          not null, primary key
#  ip_address                             :string(255)      
#  email                                  :string(255)     
#  status                                 :integer          
#  user_id                                :integer     
#  cart_id                                :integer
#  tax_number                             :integer 
#  delivery_id                            :integer        
#  shipping_status                        :integer          default(0)   
#  shipping_date                          :datetime 
#  actual_shipping_cost                   :decimal          precision(8), scale(2) 
#  express_token                          :string(255) 
#  express_payer_id                       :string(255) 
#  net_amount                             :decimal          precision(8), scale(2)
#  tax_amount                             :decimal          precision(8), scale(2) 
#  gross_amount                           :decimal          precision(8), scale(2) 
#  terms                                  :boolean          
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
class Order < ActiveRecord::Base
  attr_accessible :tax_number, :shipping_status, :shipping_date, :actual_shipping_cost, 
  :email, :delivery_id, :status, :ip_address, :user_id, :cart_id, :express_token, :express_payer_id,
  :net_amount, :tax_amount, :gross_amount, :terms, :tiers, :delivery_address_attributes
  
  has_many :order_items,                                                :dependent => :delete_all
  has_many :transactions,                                               :dependent => :delete_all

  belongs_to :cart
  belongs_to :delivery,                                                 class_name: 'DeliveryServicePrice'
  has_one :delivery_address,                                            -> { where addressable_type: 'OrderShipAddress'}, class_name: 'Address', dependent: :destroy
  has_one :billing_address,                                             -> { where addressable_type: 'OrderBillAddress'}, class_name: 'Address', dependent: :destroy

  validates :actual_shipping_cost,                                      :presence => true, :if => :completed?
  validates :email,                                                     :presence => { :message => 'is required' }, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :if => :active_or_shipping?
  validates :delivery_id,                                 :presence => { :message => 'You must select a delivery price.'}, :if => :active_or_shipping?                                                                                                                  
  validates :terms,                                                     :inclusion => { :in => [true], :message => 'You must tick the box in order to complete your order.' }, :if => :active_or_confirm?

  after_create :create_addresses

  accepts_nested_attributes_for :delivery_address

  enum shipping_status: [:pending, :dispatched]

  enum status: [:review, :billing, :shipping, :payment, :confirm, :active]

  # Upon completing an order, transfer the cart item data to new order item records 
  #
  def transfer cart
    self.order_items.destroy_all
  	cart.cart_items.each do |item|
      @order_item = order_items.build(:price => item.price, :quantity => item.quantity, :sku_id => item.sku_id, :weight => item.weight, :order_id => id)
      @order_item.build_order_item_accessory(:accessory_id => item.cart_item_accessory.accessory_id, :price => item.cart_item_accessory.price, :quantity => item.cart_item_accessory.quantity) unless item.cart_item_accessory.nil?
      @order_item.save!
  	end
  end

  # Update the current order's net_amount, tax_amount and gross_amount attribute values
  #
  # @param cart [Object]
  # @param current_tax_rate [Decimal]
  def calculate cart, current_tax_rate
    tax_amount = (cart.total_price + delivery_service_price.price)*current_tax_rate
    self.update(  :net_amount => cart.total_price,
                  :tax_amount => tax_amount,
                  :gross_amount => cart.total_price + delivery_service_price.price + tax_amount
    )
    self.save(validate: false)
  end

  # Returns a boolean on whether the order is marked as completed
  #
  # @return [Boolean]
  def completed?
    transactions.last.completed? unless transactions.empty?
  end

  # Detects if the current status of the order is 'billing'. See wicked gem for more info
  #
  # @return [Boolean]
  def active_or_billing?
    billing? ? true : active?
  end

  # Detects if the current status of the order is 'shipping'. See wicked gem for more info
  #
  # @return [Boolean]
  def active_or_shipping?
    shipping? ? true : active?
  end

  # Detects if the current status of the order is 'payment'. See wicked gem for more info
  #
  # @return [Boolean]
  def active_or_payment?
    payment? ? true : active?
  end

  # Detects if the current status of the order is 'confirm'. See wicked gem for more info
  #
  # @return [Boolean]
  def active_or_confirm?
    confirm? ? true : active?
  end
  
  # Deletes redundant orders which are more than 12 hours old
  #
  # @return [nil]
  def self.clear_orders
    where("updated_at < ? AND status != ?", 12.hours.ago, 5).destroy_all
  end

  private

  # After creating order record, create a ship and bill address to accompany it
  #
  def create_addresses
    self.build_delivery_address.save(validate: false)
    self.build_billing_address.save(validate: false)
  end
end
