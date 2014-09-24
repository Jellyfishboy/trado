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
#  delivery_service_prices        :integer(array)
#  created_at                     :datetime             not null
#  updated_at                     :datetime             not null
#
class Cart < ActiveRecord::Base
  attr_accessible :estimate_delivery_id, :estimate_country_name

  has_many :cart_items,                             dependent: :delete_all
  has_many :cart_item_accessories,                  through: :cart_items
  
  has_many :skus,                                   through: :cart_items
  has_one :order
  belongs_to :estimate_delivery,                    class_name: 'DeliveryServicePrice'

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
  #
  def calculate_delivery_services
    length = skus.map(&:length).max
    thickness = skus.map(&:thickness).max
    total_weight = cart_items.map(&:weight).sum
    delivery_service_prices = DeliveryServicePrice.where('? >= min_weight AND ? <= max_weight AND ? >= min_length AND ? <= max_length AND ? >= min_thickness AND ? <= max_thickness', total_weight, total_weight, length, length, thickness, thickness).pluck(:id)
    self.update_column(:delivery_service_prices, delivery_service_prices)
  end
  
  private

  # Deletes redundant carts which are more than 12 hours old
  #
  # @return [nil]
  def self.clear_carts
    where("updated_at < ?", 12.hours.ago).destroy_all
  end
  
end
