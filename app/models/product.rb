class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image_url, :price, :weighting, :stock, :dimensions_attributes, :category_ids, :accessory_ids, :dimension_ids, :sku, :part_number, :cost_value
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :image_url, :format => {
  	:with => %r{\.(gif|png|jpg)$}i,
  	:message => "must be a URL for GIF, JPG or PNG image."
  } # all of the above validates the attributes of products
  default_scope :order => 'weighting' #orders the products by weighting
  has_many :line_items, :dependent => :destroy, :dependent => :restrict #each product has many line items in the various carts. Restrict deletion if line items exist linked to the related product.
  has_many :orders, :through => :line_items
  has_many :categorisations, :dependent => :destroy
  has_many :categories, :through => :categorisations
  has_many :accessorisations, :dependent => :destroy
  has_many :accessories, :through => :accessorisations
  has_many :dimensionals, :dependent => :destroy
  has_many :dimensions, :through => :dimensionals
  accepts_nested_attributes_for :dimensions, :reject_if => lambda { |a| a[:size].blank? }
  mount_uploader :image_url, ProductUploader
  after_destroy :remove_image_folders # Remove carrierwave image folders after destroying a product

  def remove_image_folders
    FileUtils.remove_dir("#{Rails.root}/public/uploads/product/#{self.id}_#{self.title}", :force => true)
  end

end
