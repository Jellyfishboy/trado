# Country Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# It has and belongs to delivery services.

# == Schema Information
#
# Table name: countries
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Country < ActiveRecord::Base

  attr_accessible :name

  has_many :destinations,                               dependent: :delete_all
  has_many :delivery_services,                          through: :destinations

  validates :name,                                      uniqueness: true, presence: true
end
