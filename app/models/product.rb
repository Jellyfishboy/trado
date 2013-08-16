class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image_url, :price, :category
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :image_url, :format => {
  	:with => %r{\.(gif|png|jpg)$}i,
  	:message => "must be a URL for GIF, JPG or PNG image."
  } # all of the above validates the attributes of products
  default_scope :order => 'title' #orders the products by title
  has_many :line_items #each product has many line items in the various carts
  has_many :orders, :through => :line_items
  belongs_to :categories
  before_destroy :reference_no_line_item #before destroy the product object, execute the following method shown below
  mount_uploader :image_url, ProductUploader
  def self.category_products category_name
    where(:category => category_name)
  end

  private
  	def reference_no_line_item
  		if line_items.empty?
  		else
  			errors.add(:base, 'Line items present')
  		end # if line_items are present, it throws an error when attempting to delete the product
  	end
end
