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
#  adjusted_at :datetime
#

class StockAdjustment < ActiveRecord::Base

  attr_accessible :adjustment, :description, :sku_id, :stock_total, :duplicate

  attr_accessor :duplicate

  belongs_to :sku

  validates :description, :adjustment, :adjusted_at,             presence: true
  validate :adjustment_value

  before_save :adjust_sku_stock,                                 unless: :duplicate
  after_create :send_stock_notifications,                        unless: :duplicate
  before_validation :set_current_time_as_adjusted,               unless: :duplicate

  default_scope { order(created_at: :desc) }

  scope :active,                                                 -> { where('description IS NOT NULL') }

  # Modify the sku stock with the associated stock level adjustment value
  #
  def adjust_sku_stock
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

  # Send Stock Notifications to users
  #
  def send_stock_notifications
    SendStockNotificationsJob.perform_later(sku)
  end

  # Sets the current records adjusted_at attribute to the current time and date
  #
  def set_current_time_as_adjusted
    self.adjusted_at = Time.current
  end
end
