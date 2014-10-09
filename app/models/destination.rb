# Destination Documentation
#
# The destination table is a HABTM relationship handler between the delivery_services and countries tables.

# == Schema Information
#
# Table name: destinations
#
#  id                               :integer          not null, primary key
#  country_id                       :integer  
#  delivery_service_id              :integer          
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
class Destination < ActiveRecord::Base

  attr_accessible :country_id, :delivery_service_id

  belongs_to :country
  belongs_to :delivery_service

end
