# Country Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# It has and belongs to delivery services.
# == Schema Information
#
# Table name: countries
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  popular        :boolean          default(FALSE)
#  alpha_two_code :string
#

class Country < ActiveRecord::Base

	attr_accessible :name, :alpha_two_code

	has_many :destinations,                               dependent: :destroy
	has_many :delivery_services,                          through: :destinations
	has_many :orders,									  through: :delivery_services

	validates :name, :alpha_two_code,                     uniqueness: true, presence: true
	scope :popular,										  -> { where(popular: true) }
	scope :unpopular,									  -> { where(popular: false) }
end
