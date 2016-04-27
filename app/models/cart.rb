# Cart Documentation
#
# The cart table is designed as a session stored container (current_cart) for all the current user's cart item. 
# This is destroyed if abandoned for more than a day or the associated order has been completed.

# == Schema Information
#
# Table name: carts
#
#  id                             :integer              not null, primary key
#  estimate_delivery_id           :integer
#  estimate_country_name          :integer
#  created_at                     :datetime             not null
#  updated_at                     :datetime             not null
#
class Cart < ActiveRecord::Base
  attr_accessible :estimate_delivery_id, :estimate_country_name

  has_many :cart_items,                             dependent: :destroy
  has_many :cart_item_accessories,                  through: :cart_items
  
  has_many :skus,                                   through: :cart_items
  has_one :order
  belongs_to :estimate_delivery,                    class_name: 'DeliveryServicePrice'

  validates :estimate_country_name,                 presence: true

  # Calculates the total price of a cart
  #
  # @return [Decimal] total sum of cart items
  def total_price 
  	cart_items.to_a.sum { |item| item.total_price }
  end

  # Calculate the total for the order summary when completing the checkout process
  #
  # @param current_tax_rate [Decimal]
  # @return [Hash] net, tax and gross amounts for an order
  def calculate current_tax_rate
    @net_amount = total_price
    @tax_amount = estimate_delivery.nil? ? (@net_amount * current_tax_rate) : (@net_amount + estimate_delivery.price)*current_tax_rate
    @gross_amount = estimate_delivery.nil? ? (@net_amount + @tax_amount) : (@net_amount + estimate_delivery.price + @tax_amount)
    return {
      :net_amount => @net_amount,
      :tax_amount => @tax_amount,
      :gross_amount => @gross_amount
    }
  end

  # Calculate the relevant delivery service prices for a cart, taking into account length, thickness and weight of the total cart
  # Assign the result to the current session
  #
  def calculate_delivery_services current_tax_rate
    @cart_total = self.calculate(current_tax_rate)
    @length = skus.map(&:length).max
    @thickness = skus.map(&:thickness).max
    @total_weight = cart_items.map(&:weight).sum
    @initial_delivery_service_prices = DeliveryServicePrice.find_by_sql(['SELECT *
      FROM   delivery_service_prices d1
      WHERE  active = true
      AND    ? BETWEEN min_weight AND max_weight AND ? BETWEEN min_length AND max_length AND ? BETWEEN min_thickness AND max_thickness
      AND NOT EXISTS (
         SELECT 1
         FROM   delivery_service_prices d2
         WHERE  active = true
         AND    ? BETWEEN min_weight AND max_weight AND ? BETWEEN min_length AND max_length AND ? BETWEEN min_thickness AND max_thickness
         AND    d2.delivery_service_id = d1.delivery_service_id
         AND    d2.price < d1.price
         )', @total_weight, @length, @thickness, @total_weight, @length, @thickness]).map(&:id)
    @final_delivery_service_prices = DeliveryServicePrice.where(id: @initial_delivery_service_prices).joins(:delivery_service).where(':gross_amount > delivery_services.order_price_minimum AND (:gross_amount < delivery_services.order_price_maximum OR delivery_services.order_price_maximum IS NULL)', gross_amount: @cart_total[:gross_amount]).map(&:id)
    return @final_delivery_service_prices
  end

  # Deletes redundant carts which are more than 12 hours old
  #
  def self.clear_carts
    where("updated_at < ?", 12.hours.ago).destroy_all
  end
  
end
