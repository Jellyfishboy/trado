# Zone Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# Furthermore it also defines which delivery_service_prices are available in the country. 

# == Schema Information
#
# Table name: zones
#
#  id             :integer          not null, primary key
#  name           :string(255)               
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Zone < ActiveRecord::Base

  attr_accessible :name, :country_ids

  has_many :destinations,                       :dependent => :delete_all
  has_many :delivery_service_prices,            :through => :destinations
  has_many :zonifications,                      :dependent => :delete_all
  has_many :countries,                          :through => :zonifications

  validates :name,                              :uniqueness => true, :presence => true
  
end
