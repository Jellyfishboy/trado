class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image_url, :price
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :image_url, :format => {
  	:with => %r{\.(gif|png|jpg)$}i,
  	:message => "must be a URL for GIF, JPG or PNG image."
  } #all of the above valids the attributes of products
  default_scope :order => 'title' #orders the products by title
  has_many :line_items #each product has many line items in the various carts
  has many :orders, :through => :line_items
  before_destroy :ensure_not_referenced_by_any_line_item #before destroy the product object, execute the following method shown below

  private
  	def ensure_not_referenced_by_any_line_item
  		if line_items.empty?
  			return true
  		else
  			errors.add(:base, 'Line items present')
  			return false
  		end #if lineitems are present, it throws an error when attempting to delete the product
  	end
end
