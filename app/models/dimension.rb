class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :price, :cost_value, :stock, :stock_warning_level, :product_id
  before_destroy :check_association_number
  belongs_to :product
  validates :length, :weight, :thickness, :price, :cost_value, :stock, :stock_warning_level, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  validates :stock, :stock_warning_level, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :check_stock_values, :on => :create
  # has_many :notifications, as: :notifiable, :dependent => :delete_all
  
  def check_association_number
    product = Product.find(self.product.id)
    if product.dimensions.count < 2
      product.errors[:base] << "must have at least one dimension per product."
      return false
    end
  end

  def check_stock_values
    if self.stock && self.stock_warning_level && self.stock < self.stock_warning_level
      errors.add(:dimension, "stock warning level value must not be below your stock count.")
      return false
    end
  end


  def self.warning_level
    @restock = Dimension.where('stock < stock_warning_level').all
    if defined?(@restock)
      Notifier.low_stock(@restock).deliver
    end
  end

end
