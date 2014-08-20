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

  belongs_to :sku

  validates :description, :adjustment,                      presence: true
  validate :adjustment_value

  before_save :stock_level_adjustment, :if => :not_initial_stock_level?

  default_scope { order(created_at: :desc) }

  # Modify the sku stock with the associated stock level adjustment value
  #
  def stock_level_adjustment
    if Store::positive?(self.adjustment)
      self.sku.update_column(:stock, self.sku.stock + self.adjustment)
    else
      self.sku.update_column(:stock, self.sku.stock - self.adjustment.abs)
    end
  end

  # Determines whether this is the first stock level record for a SKU
  # If so, ignore the execution of the stock_level_adjustment method
  #
  # @return [Boolean]
  def not_initial_stock_level?
    return sku.stock_levels.count == 0 ? false : true
  end

  # Validation to check whether the adjustment value is above or below zero
  #
  # @return [Boolean]
  def adjustment_value
    if self.adjustment == 0
      errors.add(:adjustment, "must be greater or less than zero.")
      return false
    end
  end

end
