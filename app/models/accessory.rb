# Accessory Documentation
#
# The accessory table allows administrators to add additional items to a product and it's overall price.
# A product can have many accessories. The weight of accessories effects the end delivery price calculation.
# == Schema Information
#
# Table name: accessories
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  part_number :string
#  price       :decimal(8, 2)
#  weight      :decimal(8, 2)
#  cost_value  :decimal(8, 2)
#  active      :boolean          default(TRUE)
#

class Accessory < ActiveRecord::Base

  attr_accessible :name, :part_number, :price, :weight, :cost_value, :active

  has_many :cart_item_accessories
  has_many :cart_items,                                   through: :cart_item_accessories
  has_many :carts,                                        through: :cart_items
  has_many :order_item_accessories,                       dependent: :restrict_with_exception
  has_many :order_items,                                  through: :order_item_accessories, dependent: :restrict_with_exception
  has_many :orders,                                       through: :order_items
  has_many :accessorisations,                             dependent: :destroy
  has_many :products,                                     through: :accessorisations

  validates :name, :part_number, :weight,
  :price,                                                 presence: true, uniqueness: { scope: :active }

  after_update :update_cart_item_accessories_weight

  include ActiveScope
  
  # If the record's weight has changed, update all associated cart_item_accessorie parent cart_item records with the new weight
  #
  def update_cart_item_accessories_weight
    if self.weight_changed?
      cart_item_accessories = CartItemAccessory.where(:accessory_id => id)
      cart_item_accessories.each do |item|
        item.cart_item.update_column(:weight, (item.quantity*(item.cart_item.sku.weight + weight)))
      end
    end
  end

end
