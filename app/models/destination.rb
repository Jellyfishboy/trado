# Destination Documentation
#
# The destination table is a HABTM relationship handler between the shippings and zones tables.

# == Schema Information
#
# Table name: destinations
#
#  id             :integer          not null, primary key
#  zone_id        :integer  
#  shipping_id    :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Destination < ActiveRecord::Base

  attr_accessible :zone_id, :shipping_id

  belongs_to :zone
  belongs_to :shipping

end
