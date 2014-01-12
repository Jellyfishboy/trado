class Sku < ActiveRecord::Base
  attr_accessible :cost_value, :price, :sku, :stock, :stock_warning_level, :length, :weight, :thickness, :product_id, :attribute_value, :attribute_type_id, :out_of_stock
  validates :price, :cost_value, :stock, :length, :weight, :thickness, :stock_warning_level, :attribute_value, :attribute_type_id, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  validates :stock, :stock_warning_level, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :check_stock_values, :on => :create
  validates :attribute_value, :uniqueness => { :scope => :product_id }
  belongs_to :product
  belongs_to :attribute_type
  has_many :cart_items, :dependent => :restrict
  has_many :carts, :through => :cart_items
  has_many :order_items, :dependent => :restrict
  has_many :orders, :through => :order_items
  has_many :notifications, as: :notifiable, :dependent => :delete_all
  before_destroy :validate_association_count

  def check_stock_values
    if self.stock && self.stock_warning_level && self.stock <= self.stock_warning_level
      errors.add(:sku, "stock warning level value must not be below your stock count.")
      return false
    end
  end

  private

  def validate_association_count
    product = Product.find(self.product.id)
    if product.skus.count < 2
      product.errors[:base] << "You must have at least one SKU per product."
      return false
    end
  end 

end
