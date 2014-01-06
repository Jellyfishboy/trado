class Order < ActiveRecord::Base
  attr_accessible :billing_first_name, :billing_last_name, :billing_company, :billing_address, :billing_city, :billing_county, :billing_postcode, :billing_country, :billing_telephone, :shipping_first_name, :shipping_last_name, :shipping_company, :shipping_address, :shipping_city, :shipping_county, :shipping_postcode, :shipping_country, :shipping_telephone, :tax_number, :shipping_cost, :shipping_status, :shipping_date, :invoice_id, :actual_shipping_cost, :shipping_name, :email, :shipping_id, :status
  validates :billing_first_name, :billing_last_name, :billing_address, :billing_city, :billing_postcode, :billing_country, :presence => { :message => 'is required.' }, :if => :active_or_billing?
  validates :email, :shipping_first_name, :shipping_last_name, :shipping_address, :shipping_city, :shipping_postcode, :shipping_country, :presence => { :message => 'is required' }, :if => :active_or_shipping?
  validates :shipping_id, :presence => { :message => 'option is required'}, :if => :active_or_shipping?
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :if => :active_or_shipping?
  has_many :line_items, :dependent => :delete_all
  has_one :transaction, :dependent => :delete
  belongs_to :invoice
  # TODO: Refactor shipping emails in light of the new multi form setup
  # after_update :delayed_shipping, :change_shipping_status

  def add_line_items_from_cart(cart)
  	cart.line_items.each do |item|
  		item.cart_id = nil
  		line_items << item
  	end
  end

  def transaction_status
    if !self.transaction.nil? && self.transaction.payment_status == 'Completed' 
      return true 
    else 
      return false 
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
    response
    Transaction.create( :fee => response.params['PaymentInfo']['FeeAmount'], 
                        :gross_amount => response.params['PaymentInfo']['GrossAmount'], 
                        :order_id => self.id, 
                        :payment_status => response.params['PaymentInfo']['PaymentStatus'], 
                        :payment_type => response.params['PaymentInfo']['PaymentType'], 
                        :tax_amount => response.params['PaymentInfo']['TaxAmount'], 
                        :transaction_id => response.params['PaymentInfo']['TransactionID'], 
                        :transaction_type => response.params['PaymentInfo']['TransactionType'],
                        :net_amount => response.params['PaymentInfo']['GrossAmount'].to_d - response.params['PaymentInfo']['TaxAmount'].to_d - self.shipping_cost)
    self.line_items.each do |item|
      dimension = Dimension.find(item.dimension_id)
      dimension.update_column(:stock, dimension.stock-item.quantity)
    end
  end

  # Shipping methods

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
    end
  end

  def change_shipping_status
    if self.shipping_date.to_date == Date.today
      self.update_column(:shipping_status, "Dispatched")
      Notifier.order_shipped(self).deliver
    end
  end

  def dispatch_orders
    Order.all.each do |order|
      if order.shipping_date == Date.today
        order.update_column(:shipping_status, "Dispatched")
        order.order_shipped(self).deliver
      end
    end
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
