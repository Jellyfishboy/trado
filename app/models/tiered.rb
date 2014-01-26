# Tiered Documentation
#
# The tiered table is a HABTM relationship handler between the tiers and shippings tables.

# == Schema Information
#
# Table name: tiereds
#
#  id             :integer          not null, primary key
#  shipping_id     :integer
#  product_id         :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Tiered < ActiveRecord::Base

  attr_accessible :shipping_id, :tier_id

  belongs_to :shipping
  belongs_to :tier

end
