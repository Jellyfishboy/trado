class Order < ActiveRecord::Base
  attr_accessible :billing_first_name, :billing_last_name, :billing_company, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :billing_telephone, :shipping_first_name, :shipping_last_name, :shipping_company, :shipping_address, :shipping_city, :shipping_county, :shipping_postcode, :shipping_country, :shipping_telephone, :tax_number, :shipping_cost, :shipping_status, :shipping_date, :invoice_id, :actual_shipping_cost, :shipping_name, :email, :shipping_id, :status
  validates :billing_first_name, :billing_last_name, :billing_address, :billing_city, :billing_postcode, :billing_country, :presence => { :message => 'is required.' }, :if => :active_or_billing?
  validates :email, :shipping_first_name, :shipping_last_name, :shipping_address, :shipping_city, :shipping_postcode, :shipping_country, :presence => { :message => 'is required' }, :if => :active_or_shipping?
  validates :shipping_id, :presence => { :message => 'option is required'}, :if => :active_or_shipping?
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :if => :active_or_shipping?
  has_many :order_items, :dependent => :delete_all
  has_one :transaction, :dependent => :destroy
  belongs_to :invoice
  after_update :delayed_shipping, :change_shipping_status, :if => :shipping_date_nil?

  def add_cart_items_from_cart(cart)
  	cart.cart_items.each do |item|
      OrderItem.create(:price => item.price, :quantity => item.quantity, :sku_id => item.sku_id, :weight => item.weight, :order_id => self.id)
  	end
  end

  # FIXME: Possible security risk
  def calculate_order(cart, session)
    session[:sub_total] = session[:tax] = session[:total] = nil
    session[:sub_total] = cart.total_price
    session[:tax] = session[:sub_total]*0.2
    session[:total] = session[:sub_total]+session[:tax]+shipping_cost
  end

  # assign paypal token to order after user logs into their account
  def assign_paypal_token(token, payer_id, session)
    details = EXPRESS_GATEWAY.details_for(token)
    self.update_column(:express_token, token)
    self.update_column(:express_payer_id, payer_id)
    session[:paypal_email] = details.params["payer"]
  end

  def finish_order(response)
    # Create transaction
    Transaction.create( :fee => response.params['PaymentInfo']['FeeAmount'], 
                        :gross_amount => response.params['PaymentInfo']['GrossAmount'], 
                        :order_id => self.id, 
                        :payment_status => response.params['PaymentInfo']['PaymentStatus'], 
                        :payment_type => response.params['PaymentInfo']['PaymentType'], 
                        :tax_amount => response.params['PaymentInfo']['TaxAmount'], 
                        :transaction_id => response.params['PaymentInfo']['TransactionID'], 
                        :transaction_type => response.params['PaymentInfo']['TransactionType'],
                        :net_amount => response.params['PaymentInfo']['GrossAmount'].to_d - response.params['PaymentInfo']['TaxAmount'].to_d - self.shipping_cost,
                        :status_reason => transaction_reason(response))
    # Update stock quantity
    self.order_items.each do |item|
      sku = Sku.find(item.sku_id)
      sku.update_column(:stock, sku.stock-item.quantity)
      if sku.stock < 1
        sku.update_column(:out_of_stock, true)
      end
    end
    # Set order status to active
    self.update_column(:status, 'active')
  end

  # FIXME: Looks rather horrible, re factor when possible.
  def transaction_reason(response)
    if defined?(response.params['PaymentInfo']['PendingReason'])
      @reason = response.params['PaymentInfo']['PendingReason']
    else
      @reason = ""
    end
  end

  # Shipping methods

  def calculate_shipping_tier(cart)
      max_length = cart.skus.map(&:length).max
      max_thickness = cart.skus.map(&:thickness).max
      total_weight = cart.skus.map(&:weight).sum
      # FIXME: Possibly quite slow. Alot of repetition here so will revise later
      tier_raffle = []
      tier_raffle << Tier.where('? >= length_start AND ? <= length_end',max_length, max_length).pluck(:id)
      tier_raffle << Tier.where('? >= thickness_start AND ? <= thickness_end', max_thickness, max_thickness).pluck(:id)
      tier_raffle << Tier.where('? >= weight_start AND ? <= weight_end', total_weight, total_weight).pluck(:id)
      return tier_raffle.max.first
  end

  def update_shipping_information
    unless self.shipping_country.blank?
      # FIXME: Currently causing 3 db calls in order to trigger the AJAX shipping selection and store the correct country. Needs to be revised.
      country = Country.find(self.shipping_country)
      self.update_column(:shipping_country, country.name)
      shipping = Shipping.find(self.shipping_id)
      self.update_column(:shipping_cost, shipping.price)
      self.update_column(:shipping_name, shipping.name)
    end
  end

  def delayed_shipping
    if self.shipping_date_changed? && self.shipping_date_was
      Notifier.shipping_delayed(self).deliver
      binding.pry
    end
  end

  def change_shipping_status
    if self.shipping_date.to_date == Date.today
      binding.pry
      self.update_column(:shipping_status, "Dispatched")
      Notifier.order_shipped(self).deliver
    end
  end

  def shipping_date_nil?
    return false if self.shipping_date.nil?
  end

  # Multi form methods

  def active?
    status == 'active'
  end

  def active_or_billing?
    if status == 'billing' 
      return true
    else
      active?
    end
  end

  def active_or_shipping?
    if status == 'shipping' 
      return true
    else
      active?
    end
  end

  def active_or_payment?
    if status == 'payment' 
      return true
    else
      active?
    end
  end

end
