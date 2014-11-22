# StockAdjustment Documentation
#
# The stock_adjustment table records any stock adjustments made to a SKU.
# Whether by a successful order or an adjustment in the administration control panel.

# == Schema Information
#
# Table name: stock_adjustments
#
#  id                   :integer            not null, primary key
#  description          :string(255)        
#  adjustment           :integer            default(1)
#  sku_id               :integer            
#  stock_total          :integer
#  created_at           :datetime           not null
#  updated_at           :datetime           not null
#
class StockAdjustment < ActiveRecord::Base

  attr_accessible :adjustment, :description, :sku_id

  belongs_to :sku

  validates :description, :adjustment,                      presence: true
  validate :adjustment_value

  before_save :stock_adjustment, :if => :not_initial_stock_adjustment?

  default_scope { order(created_at: :desc) }

  # Modify the sku stock with the associated stock level adjustment value
  #
  def stock_adjustment
    binding.pry
    if Store::positive?(self.adjustment)
      stock_total = StockAdjustment.first.stock_total + self.adjustment
    else
      stock_total = StockAdjustment.first.stock_total - self.adjustment.abs
    end
  end

  # Determines whether this is the first stock level record for a SKU
  # If so, ignore the execution of the stock_adjustment method
  #
  # @return [Boolean]
  def not_initial_stock_adjustment?
    return sku.stock_adjustments.count == 0 ? false : true
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
