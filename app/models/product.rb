# Product Documentation
#
# The product table contains the global data for any given product. 
# It has associations to attachments, tags and skus.
# More detailed information and different product variations are maintained within the Sku table.
# == Schema Information
#
# Table name: products
#
#  id                      :integer          not null, primary key
#  name                    :string
#  description             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  weighting               :integer
#  part_number             :integer
#  sku                     :string
#  category_id             :integer
#  slug                    :string
#  meta_description        :string
#  featured                :boolean
#  active                  :boolean          default(TRUE)
#  short_description       :text
#  status                  :integer          default(0)
#  order_count             :integer          default(0)
#  page_title              :string
#  googlemerchant_brand    :string
#  googlemerchant_category :string
#

class Product < ActiveRecord::Base
  include ActiveScope
  include HasSlug
  include HasSkus
  include HasAttachments

  attr_accessible :name, :page_title, :meta_description, :description, :weighting, :sku, :part_number, 
  :accessory_ids, :attachments_attributes, :tags_attributes, :skus_attributes, :category_id, :featured,
  :short_description, :related_ids, :active, :status, :order_count, :variant_ids

  has_many :skus,                                             dependent: :destroy, inverse_of: :product
  has_many :variants,                                         through: :skus, class_name: 'SkuVariant'
  has_many :variant_types,                                    -> { uniq }, through: :variants
  has_many :active_skus,                                      -> { where(active: true) }, class_name: 'Sku'
  has_many :active_sku_variants,                              through: :active_skus, class_name: 'SkuVariant', source: :variants
  has_many :orders,                                           through: :skus
  has_many :carts,                                            through: :skus
  has_many :taggings,                                         dependent: :destroy
  has_many :tags,                                             through: :taggings, dependent: :destroy
  has_many :attachments,                                      as: :attachable, dependent: :destroy
  has_many :accessorisations,                                 dependent: :destroy
  has_many :accessories,                                      through: :accessorisations
  has_and_belongs_to_many :related,                           class_name: "Product", 
                                                              join_table: :related_products, 
                                                              foreign_key: :product_id, 
                                                              association_foreign_key: :related_id
  belongs_to :category

  validates :name, :sku, :part_number,                        presence: true
  validates :meta_description, :description, 
  :weighting, :category_id, :page_title,                      presence: true, if: :published?
  validates :part_number, :sku, :name,                        uniqueness: { scope: :active }
  validates :page_title,                                      length: { maximum: 70, message: :too_long }
  validates :meta_description,                                length: { maximum: 150, message: :too_long }, if: :published?
  validates :name,                                            length: { minimum: 10, message: :too_short }, if: :published?
  validates :description,                                     length: { minimum: 20, message: :too_short }, if: :published?
  validates :short_description,                               length: { maximum: 300, message: :too_long }, if: :published?
  validates :part_number,                                     numericality: { only_integer: true }, if: :published?

  accepts_nested_attributes_for :skus
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :attachments
  
  default_scope { order(weighting: :desc) }

  scope :published_or_archived,                               -> { where(status: [0,2]) } 
  scope :search,                                              ->(query, page, per_page_count, limit_count) { joins(:tags).where("lower(products.name) LIKE :search OR lower(products.sku) LIKE :search OR lower(tags.name) LIKE :search", search: "%#{query}%").uniq.limit(limit_count).page(page).per(per_page_count) }

  enum status: [:draft, :published, :archived]

  # Find all associated variants by their variant type
  # @param variant_type [String]
  #
  def variant_collection_by_type variant_type
    variants.joins(:variant_type).where(variant_types: { name: variant_type })
  end
  
  # If a product has only one SKU it returns true
  # Else if the product has more than one SKU, returns false
  #
  # @return [Boolean]
  def single?
    skus.active.map(&:active).count == 1 ? true : false
  end

  # Due to the way the 'status' functionality has been set up
  # The product needs to always update slug upon create/update
  #
  # @return [Boolean]
  def should_generate_new_friendly_id?
    true
  end

  # Checks if the product has any stock
  #
  # @return [Boolean]
  def in_stock?
    skus.active.map(&:in_stock?).include?(true) ? true : false
  end

  # Gets the first available active sku for the product
  #
  # @return [Object] sku record
  def first_available_sku
    skus.active.in_stock.order(price: :asc).first
  end
end
