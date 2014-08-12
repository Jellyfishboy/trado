# Zonification Documentation
#
# The destination table is a HABTM relationship handler between the zones and countries tables.

# == Schema Information
#
# Table name: zonifications
#
#  id             :integer          not null, primary key
#  country_id     :integer  
#  zone_id        :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Zonification < ActiveRecord::Base

  attr_accessible :country_id, :zone_id

  belongs_to :zone
  belongs_to :country
end