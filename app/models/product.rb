# Product Documentation
#
# The product table contains the global data for any given product. 
# It has associations to attachments, tags and skus.
# More detailed information and different product variations are maintained within the Sku table.

# == Schema Information
#
# Table name: products
#
#  id                       :integer            not null, primary key
#  part_number              :string      
#  name                     :string(255)
#  description              :text
#  short_description        :text
#  page_title               :string(255)
#  meta_description         :string(255)
#  weighting                :integer 
#  sku                      :string(255)
#  featured                 :boolean 
#  active                   :boolean            default(true)
#  category_id              :integer    
#  status                   :integer            default(0)
#  order_count              :integer            default(0)
#  slug                     :string(255)
#  created_at               :datetime           not null
#  updated_at               :datetime           not null
#
class Product < ActiveRecord::Base

  attr_accessible :name, :page_title, :meta_description, :description, :weighting, :sku, :part_number, 
  :accessory_ids, :attachments_attributes, :tags_attributes, :skus_attributes, :category_id, :featured,
  :short_description, :related_ids, :active, :status, :order_count, :variant_ids

  has_many :skus,                                             dependent: :delete_all, inverse_of: :product
  has_many :orders,                                           through: :skus
  has_many :carts,                                            through: :skus
  has_many :taggings,                                         dependent: :delete_all
  has_many :tags,                                             through: :taggings, dependent: :delete_all
  has_many :attachments,                                      as: :attachable, dependent: :delete_all
  has_many :accessorisations,                                 dependent: :delete_all
  has_many :accessories,                                      through: :accessorisations
  has_and_belongs_to_many :related,                           class_name: "Product", 
                                                              join_table: :related_products, 
                                                              foreign_key: :product_id, 
                                                              association_foreign_key: :related_id
  belongs_to :category
  has_many :variants,                                         through: :skus, class_name: 'SkuVariant'
  has_many :variant_types,                                    -> { uniq }, through: :variants

  validates :name, :sku, :part_number,                        presence: true, :if => :draft? || :published?
  validates :meta_description, :description, 
  :weighting, :category_id, :page_title,                      presence: true, :if => :published?
  validates :part_number, :sku, :name,                        uniqueness: { scope: :active }
  validates :page_title,                                      length: { maximum: 70, message: :too_long }
  validates :meta_description,                                length: { maximum: 150, message: :too_long }, :if => :published?
  validates :name,                                            length: { minimum: 10, message: :too_short }, :if => :published?
  validates :description,                                     length: { minimum: 20, message: :too_short }, :if => :published?
  validates :short_description,                               length: { maximum: 150, message: :too_long }, :if => :published?
  validates :part_number,                                     numericality: { only_integer: true, greater_than_or_equal_to: 1 }, :if => :published?                                                         
  validate :attachment_count,                                 :if => :published?
  validate :sku_count,                                        :if => :published?
  validate :sku_attributes,                                   :if => :published?
  
  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :skus

  default_scope { order(weighting: :desc) }

  scope :search,                                              ->(query, page, per_page_count, limit_count) { where("name LIKE :search OR sku LIKE :search", search: "%#{query}%").limit(limit_count).page(page).per(per_page_count) }

  enum status: [:draft, :published]

  include ActiveScope
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]


  # Find all associated variants by their variant type
  # @param variant_type [String]
  #
  def variant_collection_by_type variant_type
    variants.joins(:variant_type).where(variant_types: { name: variant_type })
  end

  # Calculate if a product has at least one associated attachment
  # If no associated attachments exist, return an error
  #
  def attachment_count
    if self.attachments.map(&:default_record).count == 0
      errors.add(:product, " must have at least one attachment.")
      return false
    end
  end

  # Calculate if a product has at least one associated SKU
  # If no associated SKUs exist, return an error
  #
  def sku_count
    if self.skus.map(&:active).count == 0
      errors.add(:product, " must have at least one variant.")
      return false
    end
  end

  # Checks if all the associated skus are valid when publishing the product
  # If not, returns a helpful error for the user
  # 
  def sku_attributes
    if self.skus.active.map(&:valid?).include?(false)
      errors.add(:base, "You must complete all variants before publishing the product.")
      return false
    end
  end
  
  # If a product has only one SKU it returns true
  # Else if the product has more than one SKU, returns false
  #
  # @return [Boolean]
  def single?
    skus.map(&:active).count == 1 ? true : false
  end

  # Due to the way the 'status' functionality has been set up
  # The product needs to always update slug upon create/update
  #
  # @return [Boolean]
  def should_generate_new_friendly_id?
    true
  end
end
