# Destination Documentation
#
# The destination table is a HABTM relationship handler between the shippings and countries tables.

# == Schema Information
#
# Table name: destinations
#
#  id             :integer          not null, primary key
#  counrty_id     :integer  
#  shipping_id    :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Destination < ActiveRecord::Base

  attr_accessible :country_id, :shipping_id

  belongs_to :shipping
  belongs_to :country

end
