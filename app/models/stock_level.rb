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
  validate                                                  { errors.add(:adjustment, "must be greater or less than zero") if adjustment == 0 }

  belongs_to :sku

  before_save :validate_stock

  default_scope order('created_at DESC')

  # Validation to check to prevent a negative stock value; if not the case modify the sku stock with the associated stock level adjustment value
  #
  # @return [boolean]
  def validate_stock
    unless !Store::positive?(self.adjustment) && self.adjustment.abs > self.sku.stock
      if Store::positive?(self.adjustment)
        self.sku.update_column(:stock, self.sku.stock + self.adjustment)
      else
        self.sku.update_column(:stock, self.sku.stock - self.adjustment.abs)
      end
    else
      errors.add(:stock_level, "can't   reduce the SKU stock to a negative value.")
      return false
    end
  end

end
