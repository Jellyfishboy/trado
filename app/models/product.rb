class Product < ActiveRecord::Base
  attr_accessible :name, :description, :weighting, :stock, :sku, :part_number, :stock_warning_level, :category_ids, :accessory_ids, :attachments_attributes, :tags_attributes, :dimensions_attributes
  validates :name, :description, :part_number, :sku, :stock, :stock_warning_level, :weighting, :presence => true
  validates :part_number, :sku, :name, :uniqueness => true
  validates :part_number, :stock, :stock_warning_level, :weighting, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validates :name, :length => {:minimum => 10, :message => :too_short}
  validates :description, :length => {:minimum => 20, :message => :too_short}
  validates :dimensions, :tier => true, :on => :save
  default_scope :order => 'weighting' #orders the products by weighting
  has_many :line_items, :dependent => :destroy, :dependent => :restrict #each product has many line items in the various carts. Restrict deletion if line items exist linked to the related product.
  has_many :orders, :through => :line_items
  has_many :categorisations, :dependent => :delete_all
  has_many :categories, :through => :categorisations
  has_many :accessorisations, :dependent => :delete_all
  has_many :accessories, :through => :accessorisations
  has_many :dimensionals, :dependent => :delete_all
  has_many :dimensions, :through => :dimensionals
  has_many :taggings, :dependent => :delete_all
  has_many :tags, :through => :taggings
  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :dimensions
  after_destroy :remove_image_folders # Remove carrierwave image folders after destroying a product
  # before_create :validate_img_dimensions

  def remove_image_folders
    FileUtils.remove_dir("#{Rails.root}/public/uploads/attachment/Product/#{self.id}", :force => true)
  end

  def self.warning_level
    @restock = Product.where('stock < stock_warning_level').all
    @restock.each do |restock|
      Notifier.low_stock(restock).deliver
    end
  end

  # def validate_img_dimensions
    
  # end
end
