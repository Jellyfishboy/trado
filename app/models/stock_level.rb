# StockLevel Documentation
#
# The stock_level table records any stock adjustments made to a SKU.
# Whether by a successful order or an adjustment in the administration control panel.

# == Schema Information
#
# Table name: stock_levels
#
#  id                   :integer            not null, primary key
#  description          :string(255)        
#  adjustment           :integer            default(0)
#  sku_id               :integer            
#  created_at           :datetime           not null
#  updated_at           :datetime           not null
#
class StockLevel < ActiveRecord::Base

  attr_accessible :adjustment, :description, :sku_id

  validates :description, :adjustment,                      :presence => true
  validates :description,                                   :length => { :minimum => 5, :message => :too_short }

  belongs_to :sku

end
