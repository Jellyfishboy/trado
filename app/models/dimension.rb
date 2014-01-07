class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :product_id
  before_destroy :check_association_number
  belongs_to :product
  has_many :variant_values, :as => :variants
  validates :length, :weight, :thickness, :presence => true
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  
  def check_association_number
    product = Product.find(self.product.id)
    if product.dimensions.count < 2
      product.errors[:base] << "must have at least one dimension per product."
      return false
    end
  end

end
