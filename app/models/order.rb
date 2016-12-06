# Order Documentation
#
# The order table handles all the data associated to a current, completed or failed order. 
# It is updated throughout the order process and discarded if the order is not completed within 2 days. 
# Each order has an associated transaction which contains more information on the payment process. 
# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  email                :string
#  shipping_date        :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  actual_shipping_cost :decimal(8, 2)
#  delivery_id          :integer
#  ip_address           :string
#  user_id              :integer
#  net_amount           :decimal(8, 2)
#  gross_amount         :decimal(8, 2)
#  tax_amount           :decimal(8, 2)
#  terms                :boolean
#  cart_id              :integer
#  shipping_status      :integer          default(0)
#  consignment_number   :string
#  payment_type         :integer
#  browser              :string
#  status               :integer          default(0)
#

require 'reportatron_4000'
require 'modulatron_4000'

class Order < ActiveRecord::Base
  include HasShippingDateValidation
  include HasOrderAddresses

	attr_accessible :shipping_status, :shipping_date, :actual_shipping_cost, 
	:email, :delivery_id, :ip_address, :user_id, :cart_id, :net_amount, :tax_amount, 
    :gross_amount, :terms, :delivery_service_prices, :delivery_address_attributes, :billing_address_attributes, :created_at, :consignment_number, :payment_type, :browser, :status
    
	has_many :order_items,                                                dependent: :destroy
	has_many :transactions,                                               -> { order('created_at DESC, id DESC') }, dependent: :destroy
	has_many :products,                                                   through: :order_items
	has_many :skus,                                                       through: :order_items

	belongs_to :cart
	belongs_to :delivery,                                                 class_name: 'DeliveryServicePrice'
	has_one :delivery_service,                                            through: :delivery

	validates :email,                                                     presence: { message: 'is required' }, format: { with: Devise::email_regexp }
	validates :delivery_id,                                               presence: { message: 'Delivery option must be selected.'}                                                                                                                  
	validates :terms,                                                     inclusion: { :in => [true], message: 'You must tick the box in order to place your order.' }
    validates :payment_type,                                              presence: true
    validate :tracking_assignment                                        

	scope :complete,                                                      -> { active.includes(:transactions).where.not(transactions: { order_id: nil } ).order('transactions.created_at DESC, transactions.id DESC') }
  scope :incomplete,                                                    ->{ includes(:transactions).where(transactions: { order_id: nil } ) }

	scope :count_per_month,                                               -> { active.order("EXTRACT(month FROM transactions.updated_at)").group("EXTRACT(month FROM transactions.updated_at)").count }

	scope :last_transaction_collection,                                   -> { select('DISTINCT orders.id').joins(:transactions).active.where("transactions.created_at = (SELECT MAX(transactions.created_at) FROM transactions WHERE transactions.order_id = orders.id)") }

	scope :pending_collection,                                            -> { last_transaction_collection.where(transactions: { payment_status: 0 } ) }

	scope :completed_collection,                                          -> { last_transaction_collection.where(transactions: { payment_status: 1 } ) }

	scope :failed_collection,                                             -> { last_transaction_collection.where(transactions: { payment_status: 2 } ) }

	scope :gross_total,                                                   -> { completed_collection.sum('transactions.gross_amount') }

	scope :net_total,                                                     -> { completed_collection.sum('transactions.net_amount') }

	scope :tax_total,                                                     -> { completed_collection.sum('transactions.tax_amount') }

  scope :dispatch_today_or_past,                                        -> { where('EXTRACT(day from shipping_date) = :day AND EXTRACT(month from shipping_date) = :month AND EXTRACT(year from shipping_date) = :year OR shipping_date < :current_datetime', day: Date.current.day, month: Date.current.month, year: Date.current.year, current_datetime: Time.current) }

	 accepts_nested_attributes_for :delivery_address
	 accepts_nested_attributes_for :billing_address

    auto_strip_attributes :email

	  enum shipping_status: [:pending, :dispatched]
    enum payment_type: [:paypal, :stripe]
    enum status: [:active, :cancelled]

  	# Upon completing the checkout process, transfer the cart item data to new order item records 
  	#
  	# @param cart [Object]
  	def transfer cart
  		self.order_items.destroy_all
  		cart.cart_items.each do |item|
  			@order_item = order_items.build(price: item.price, quantity: item.quantity, sku_id: item.sku_id, weight: item.weight, order_id: id)
  			@order_item.build_order_item_accessory(accessory_id: item.cart_item_accessory.accessory_id, price: item.cart_item_accessory.price, quantity: item.cart_item_accessory.quantity) unless item.cart_item_accessory.nil?
  			@order_item.save!
  		end
  	end

  	# Update the current order's net_amount, tax_amount and gross_amount attribute values
  	# And assigns the order to the current_cart stored in session
  	#
  	# @param cart [Object]
  	# @param current_tax_rate [Decimal]
  	def calculate cart, current_tax_rate
      net_amount = cart.total_price + (delivery.try(:price) || 0)
      tax_amount = net_amount * current_tax_rate
      self.attributes = { cart_id: cart.id, net_amount: net_amount, tax_amount: tax_amount, gross_amount: net_amount + tax_amount }
      self.save(validate: false)
  	end

  	# Returns true if the last associated transaction to the order is marked as complete
  	#
  	# @return [Boolean]
  	def completed?
  		latest_transaction.completed? unless transactions.empty?
  	end

  	def changed_shipping_date?
  		completed? && dispatched? && shipping_date_changed? ? true : false
  	end

  	def self.dashboard_data
  		return {
	  		:completed => completed_collection.count,
	  		:pending => pending_collection.count,
	  		:failed => failed_collection.count,
	  		:gross_total => gross_total,
	  		:net_total => net_total,
	  		:tax_total => tax_total,
	  		:completed_per_month => Reportatron4000.parse_count_per_month(Order.completed_collection.count_per_month),
	  		:failed_per_month => Reportatron4000.parse_count_per_month(Order.failed_collection.count_per_month),
	  		:provider_fee_total => completed_collection.sum('transactions.fee'),
        :delivery_fees => completed_collection.joins(:delivery).sum('delivery_service_prices.price'),
        :active_carts => Cart.all.count,
        :incomplete_orders => Order.incomplete.count
  		}
  	end

    def self.pie_datasets
      dataset = {}
      dataset = dataset.merge(paypal: { value: Order.complete.paypal.count, color: "#00aff1" }) if Modulatron4000.paypal?
      dataset = dataset.merge(stripe: { value: Order.complete.stripe.count, color: "#6772e5" }) if Modulatron4000.stripe?
      return dataset
    end

    def tracking?
      consignment_number.nil? || delivery_service.tracking_url.nil? ? false : true
    end

    def tracking_assignment
      if consignment_number.present? && !delivery_service.tracking_url.present?
          errors.add(:consignment_number, "can't be set when there is no tracking URL.")
          return false
      end
    end

    def latest_transaction
      transactions.first
    end

    def restore_stock!
      if self.cancelled?
        self.order_items.each do |item|
          sku = Sku.find(item.sku_id)
          description = "Cancelled Order ##{self.id}"
          stock_adjustment = StockAdjustment.new(description: description, adjustment: item.quantity, sku_id: item.sku_id)
          stock_adjustment.save!
        end
      end
    end

    def has_pending_delivery_datetime?
      pending? && shipping_date.present? ? true : false
    end

    def last_error_code
      latest_transaction.error_code
    end

    def customer_payment_type
      stripe? ? stripe_card_brand : payment_type
    end
end
