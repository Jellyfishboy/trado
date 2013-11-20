class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :price, :cost_value
  has_many :dimensionals, :dependent => :delete_all
  belongs_to :product, :dependent => :destroy
  validates :length, :weight, :thickness, :price, :cost_value, :presence => true
  validates :price, :cost_value, :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness, :numericality => { :greater_than_or_equal_to => 0 }
  # before_destroy :check_association_number

  # private
  
  # def check_association_number
  #   binding.pry
  #   product = Product.find(self.attachable_id)
  #   if product.attachments.count < 2
  #       binding.pry
  #       flash[:error] = "You must have at least one attachment per product."
  #       return false
  #   end
  # end
end
