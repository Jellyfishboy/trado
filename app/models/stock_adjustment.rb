# StockAdjustment Documentation
#
# The stock_adjustment table records any stock adjustments made to a SKU.
# Whether by a successful order or an adjustment in the administration control panel.
# == Schema Information
#
# Table name: stock_adjustments
#
#  id          :integer          not null, primary key
#  description :string
#  adjustment  :integer          default(1)
#  sku_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  stock_total :integer
#

class StockAdjustment < ActiveRecord::Base

  attr_accessible :adjustment, :description, :sku_id, :stock_total

  belongs_to :sku

  validates :description, :adjustment,                      presence: true
  validate :adjustment_value

  before_save :stock_adjustment
  after_create :send_stock_notifications

  default_scope { order(created_at: :desc) }

  scope :active,                                            -> { where('description IS NOT NULL') }

  # Modify the sku stock with the associated stock level adjustment value
  #
  def stock_adjustment
    if Store.positive?(self.adjustment)
      self.stock_total = self.sku.stock + self.adjustment
      self.sku.update_column(:stock, self.sku.stock + self.adjustment)
    else
      self.stock_total = self.sku.stock - self.adjustment.abs
      self.sku.update_column(:stock, self.sku.stock - self.adjustment.abs)
    end
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

  def send_stock_notifications
    SendStockNotificationsJob.perform_later(sku)
  end
end
