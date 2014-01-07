class Sku < ActiveRecord::Base
  attr_accessible :cost_value, :price, :sku, :stock, :stock_warning_level
  validates :price, :cost_value, :stock, :stock_warning_level, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :stock, :stock_warning_level, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :check_stock_values, :on => :create
  has_many :variant_values, :as => :variants
  has_many :dimensions, :through => :variants

  def check_stock_values
    if self.stock && self.stock_warning_level && self.stock < self.stock_warning_level
      errors.add(:sku, "stock warning level value must not be below your stock count.")
      return false
    end
  end

  def self.warning_level
    @restock = Sku.where('stock < stock_warning_level').all
    if defined?(@restock)
      Notifier.low_stock(@restock).deliver
    end
  end
end
