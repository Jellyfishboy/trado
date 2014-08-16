# DeliveryServicePrice Documentation
#
# The delivery_service_price table contains a list of available delivery prices for a type of delivery service. 
# Each with a description and price and dimension parameters.

# == Schema Information
#
# Table name: delivery_service_prices
#
#  id                       :integer          not null, primary key
#  code                     :string(255)          
#  price                    :decimal          precision(8), scale(2)
#  description              :text          
#  min_weight               :decimal          precision(8), scale(2)
#  max_weight               :decimal          precision(8), scale(2)
#  min_length               :decimal          precision(8), scale(2)
#  max_length               :decimal          precision(8), scale(2)
#  min_thickness            :decimal          precision(8), scale(2)
#  max_thickness            :decimal          precision(8), scale(2)
#  delivery_service_id      :integer          not null
#  active                   :boolean          default(true)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class DeliveryServicePrice < ActiveRecord::Base

  attr_accessible :code, :price, :description, :min_weight, :max_weight, :min_length, :max_length, 
  :min_thickness, :max_thickness, :active, :delivery_service_id

  has_many :orders,                                                     foreign_key: :delivery_id, dependent: :restrict_with_exception
  belongs_to :delivery_service
  has_many :countries,                                                  through: :delivery_service

  validates :code, :price, :min_weight, :max_weight,
  :min_length, :max_length, :min_thickness, :max_thickness,             presence: true
  validates :code,                                                      uniqueness: { scope: [:active, :delivery_service_id] }
  validates :description,                                               length: { maximum: 180, message: :too_long }
  validates :price,                                                     format: { with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/ }

  default_scope { order(price: :asc) }
  scope :find_collection,                                               ->(cart, country) { joins(:countries).where(delivery_service_prices: { id: cart.order.delivery_service_prices }, countries: { :name => country }).load }

  include ActiveScope

  # Returns a string of the parent delivery service courier_name and name attributes concatenated
  #
  # @return [String] delivery service courier and name
  def full_name
    delivery_service.full_name
  end

  # If the parent delivery service has no description use the delivery service price description
  # The delivery service description wills override the delivery service price
  #
  # @return [String] delivery description
  def full_description
    delivery_service.description.nil? ? description : delivery_service.description
  end

end
