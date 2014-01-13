class Product < ActiveRecord::Base
  attr_accessible :name, :meta_description, :description, :weighting, :sku, :part_number, :accessory_ids, :attachments_attributes, :tags_attributes, :skus_attributes, :category_id, :featured
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, :meta_description, :description, :part_number, :sku, :weighting, :presence => true
  validates :part_number, :sku, :name, :uniqueness => true
  validates :part_number, :weighting, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validates :name, :meta_description, :length => {:minimum => 10, :message => :too_short}
  validates :description, :length => {:minimum => 20, :message => :too_short}
  validates :skus, :tier => true, :on => :save
  default_scope :order => 'weighting' #orders the products by weighting
  has_many :skus, :dependent => :restrict
  has_many :orders, :through => :skus
  has_many :carts, :through => :skus
  belongs_to :category
  has_many :accessorisations, :dependent => :delete_all
  has_many :accessories, :through => :accessorisations
  has_many :taggings, :dependent => :delete_all
  has_many :tags, :through => :taggings
  has_many :attachments, as: :attachable, :dependent => :delete_all
  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :skus
  accepts_nested_attributes_for :category
  after_destroy :remove_image_folders # Remove carrierwave image folders after destroying a product
  before_create :assign_sku_references

  searchable do
    text :name
    text :tags do
      tags.map { |tag| tag.name }
    end
    text :skus do 
      skus.map { |sku| sku.sku }
    end
    text :part_number
  end

  def assign_sku_references
    self.skus.each do |sku|
      suffix = sku.attribute_value.tr(".","-")
      sku.sku = "#{self.sku}-#{suffix}"
    end
  end

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
