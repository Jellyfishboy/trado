# DeliveryServicePrice Documentation
#
# The delivery_service_price table contains a list of available delivery prices for a type of delivery service. 
# Each with a description and price and dimension parameters.
# == Schema Information
#
# Table name: delivery_service_prices
#
#  id                  :integer          not null, primary key
#  code                :string
#  price               :decimal(8, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  description         :text
#  active              :boolean          default(TRUE)
#  min_weight          :decimal(8, 2)
#  max_weight          :decimal(8, 2)
#  min_length          :decimal(8, 2)
#  max_length          :decimal(8, 2)
#  min_thickness       :decimal(8, 2)
#  max_thickness       :decimal(8, 2)
#  delivery_service_id :integer
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
  validates :price,                                                     format: { with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/ }, uniqueness: { scope: :delivery_service_id }

  scope :find_collection,                                               ->(delivery_service_prices, country) { joins(:countries).where(delivery_service_prices: { id: delivery_service_prices }, countries: { name: country }).uniq.load }

  include ActiveScope

  # Returns a string of the parent delivery service courier_name and name attributes concatenated
  #
  # @return [String] delivery service courier and name
  def full_name
    delivery_service.full_name
  end

  # If the delivery service price has no description, use the delivery service description
  # Individual delivery service price descriptions will override the delivery service description
  #
  # @return [String] delivery description
  def full_description
    description.nil? ? delivery_service.description : description
  end

end
