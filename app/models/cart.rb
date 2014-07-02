# Cart Documentation
#
# The cart table is designed as a session stored container (current_cart) for all the current user's cart item. 
# This is destroyed if abandoned for more than a day or the associated order has been completed.

# == Schema Information
#
# Table name: carts
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Cart < ActiveRecord::Base

  has_many :cart_items,                         :dependent => :delete_all
  has_many :cart_item_accessories,              :through => :cart_items
  
  has_many :skus,                               :through => :cart_items
  has_one :order

  # Calculates the total price of a cart
  #
  # @return [Decimal] total sum of cart items
  def total_price 
  	cart_items.to_a.sum { |item| item.total_price }
  end
  
  private

  # Deletes redundant carts which are more than 12 hours old
  #
  # @return [nil]
  def self.clear_carts
    where("updated_at < ?", 12.hours.ago).destroy_all
  end
  
end
