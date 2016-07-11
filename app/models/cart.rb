# Cart Documentation
#
# The cart table is designed as a session stored container (current_cart) for all the current user's cart item. 
# This is destroyed if abandoned for more than a day or the associated order has been completed.
# == Schema Information
#
# Table name: carts
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  delivery_id          :integer
#  country              :string
#  delivery_service_ids :text
#

class Cart < ActiveRecord::Base
  attr_accessible :delivery_id, :country, :delivery_service_ids

  serialize :delivery_service_ids, Array

  has_many :cart_items,                             dependent: :destroy
  has_many :cart_item_accessories,                  through: :cart_items
  has_many :skus,                                   through: :cart_items
  has_one :order
  belongs_to :delivery,                             class_name: 'DeliveryServicePrice'

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
  def calculate current_tax_rate, delivery_price=nil
    delivery = delivery_price.nil? ? (delivery.try(:price) || 0) : delivery_price
    subtotal = (total_price + delivery)
    tax = subtotal * current_tax_rate
    return {
      subtotal: subtotal,
      tax: tax,
      delivery: delivery,
      total: subtotal + tax
    }
  end

  # Calculate the relevant delivery service prices for a cart, taking into account length, thickness and weight of the total cart
  # Assign the result to the current session
  #
  def calculate_delivery_services current_tax_rate
    cart_total = self.calculate(current_tax_rate)
    length = skus.map(&:length).max
    thickness = skus.map(&:thickness).max
    total_weight = cart_items.map(&:weight).sum
    initial_delivery_service_prices = DeliveryServicePrice.find_by_sql(['SELECT *
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
         )', total_weight, length, thickness, total_weight, length, thickness]).map(&:id)
    final_delivery_service_prices = DeliveryServicePrice.active.where(id: initial_delivery_service_prices).joins(:delivery_service).where(':total > delivery_services.order_price_minimum AND (:total < delivery_services.order_price_maximum OR delivery_services.order_price_maximum IS NULL)', total: cart_total[:total]).map(&:id)
    return final_delivery_service_prices
  end

  # Deletes redundant carts which are more than 12 hours old
  #
  def self.clear_carts
    where("updated_at < ?", 12.hours.ago).destroy_all
  end
end
