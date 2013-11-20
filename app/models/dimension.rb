class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :price, :cost_value
  before_destroy :check_association_number
  has_one :dimensional, :dependent => :destroy
  has_one :product, :through => :dimensional
  validates :length, :weight, :thickness, :price, :cost_value, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  
  
  def check_association_number
    product = Product.find(self.product.id)
    if product.dimensions.count < 2
        product.errors[:base] << "You must have at least one dimension per product."
        return false
    end
  end
end
