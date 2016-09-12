# Country Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# It has and belongs to delivery services.
# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  popular          :boolean          default(FALSE)
#  alpha_two_code   :string
#  alpha_three_code :string
#  currency         :string
#  transactional    :boolean          default(FALSE)
#

class Country < ActiveRecord::Base

	attr_accessible :name, :alpha_two_code, :alpha_three_code, :currency

	has_many :destinations,                               dependent: :destroy
	has_many :delivery_services,                          through: :destinations

    has_many :address_countries,                          dependent: :destroy
    has_many :addresses,                                  through: :address_countries
    has_many :delivery_addresses,                         -> { where addressable_type: 'OrderShipAddress' }, through: :address_countries, source: :address 
    has_many :orders,                                     through: :delivery_addresses
    has_many :products,                                   through: :orders

	validates :name, :alpha_two_code,                     uniqueness: true, presence: true
	scope :popular,										  -> { where(popular: true).includes(:products).order('products.order_count DESC') }
	scope :unpopular,									  -> { where(popular: false) }
    scope :transactional,                                 -> { where(transactional: true) }
end
