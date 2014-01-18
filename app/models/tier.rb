# Tier Documentation
#
# The tier table is a concept of separating shipping methods into separate dimensional brackets. 
# When an order is being calculated, it collects the sum or max of length, weight and thickness to then pick a relevant tier. 
# The seleted tier then has a list of available shipping methods for the submitted dimensions.

# == Schema Information
#
# Table name: tiers
#
#  id                  :integer          not null, primary key
#  length_start        :decimal          precision(8), scale(2)          
#  length_end          :decimal          precision(8), scale(2)
#  weight_start        :decimal          precision(8), scale(2)
#  weight_end          :decimal          precision(8), scale(2)
#  thickness_start     :decimal          precision(8), scale(2)
#  thickness_end       :decimal          precision(8), scale(2)         
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Tier < ActiveRecord::Base

  attr_accessible :length_end, :length_start, :thickness_end, :thickness_start, :weight_end, :weight_start, :shipping_ids

  has_many :tiereds,                            :dependent => :delete_all
  has_many :shippings,                          :through => :tiereds

  validates :length_end, :length_start, 
  :thickness_end, :thickness_start, 
  :weight_end, :weight_start,                   :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

end
