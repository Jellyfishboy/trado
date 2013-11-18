class Product < ActiveRecord::Base
  attr_accessible :name, :description, :weighting, :stock, :dimensions_attributes, :category_ids, :accessory_ids, :dimension_ids, :sku, :part_number, :stock_warning_level, :tag_ids, :attachments_attributes
  validates :name, :description, :presence => true
  validates :name, :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  # validates :attachment, :format => {
  # 	:with => %r{\.(gif|png|jpg)$}i,
  # 	:message => "must be a URL for GIF, JPG or PNG image."
  # } # all of the above validates the attributes of products
  validates :dimensions, :tier => true, :on => :create
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
  accepts_nested_attributes_for :dimensions, :reject_if => lambda { |a| a[:length].blank? }
  after_destroy :remove_image_folders # Remove carrierwave image folders after destroying a product

  def remove_image_folders
    FileUtils.remove_dir("#{Rails.root}/public/uploads/attachment/Product/#{self.id}", :force => true)
  end

  def self.warning_level
    @restock = Product.where('stock < stock_warning_level').all
    @restock.each do |restock|
      Notifier.low_stock(restock).deliver
    end
  end

end
