class Sku < ActiveRecord::Base
  attr_accessible :cost_value, :price, :sku, :stock, :stock_warning_level, :length, :weight, :thickness, :product_id, :attribute_values_attributes
  validates :price, :cost_value, :stock, :length, :weight, :thickness, :stock_warning_level, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  validates :stock, :stock_warning_level, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :check_stock_values, :on => :create
  has_many :attribute_values, :dependent => :delete_all
  belongs_to :product
  accepts_nested_attributes_for :attribute_values
  before_destroy :check_association_count

  def self.warning_level
    @restock = Sku.where('stock < stock_warning_level').all
    if defined?(@restock)
      Notifier.low_stock(@restock).deliver
    end
  end

  def check_stock_values
    if self.stock && self.stock_warning_level && self.stock < self.stock_warning_level
      errors.add(:sku, "stock warning level value must not be below your stock count.")
      return false
    end
  end

  def check_association_count
    product = Product.find(self.product.id)
    if product.skus.count < 2
      return false
    end
  end  
end
