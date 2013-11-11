class Product < ActiveRecord::Base
  attr_accessible :name, :description, :image_url, :weighting, :stock, :dimensions_attributes, :category_ids, :accessory_ids, :dimension_ids, :sku, :part_number, :stock_warning_level, :tag_ids
  validates :name, :description, :image_url, :presence => true
  validates :name, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
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
  has_many :taggings
  has_many :tags, :through => :taggings
  accepts_nested_attributes_for :dimensions, :reject_if => lambda { |a| a[:length].blank? }
  mount_uploader :image_url, ProductUploader
  after_destroy :remove_image_folders # Remove carrierwave image folders after destroying a product
  before_create :check_tiers

  def remove_image_folders
    FileUtils.remove_dir("#{Rails.root}/public/uploads/product/#{self.id}_#{self.name}", :force => true)
  end

  def self.warning_level
    @restock = Product.where('stock < stock_warning_level')
    @restock.each do |restock|
      Notifier.low_stock(restock).deliver
    end
  end

  #TODO: Throw an error on the form when dimension exceeds the tier maximum values
  def check_tiers
    self.dimensions.each do |dimension|
      if dimension.length > Tier.maximum("length_end") || dimension.weight > Tier.maximum("weight_end") || Tier.maximum("thickness_end")
        errors.add(:dimension_ids, "do not have any suitable postage tiers available.")
        puts "ERROR"
      end
    end
  end

end
