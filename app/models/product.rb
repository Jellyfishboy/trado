# Product Documentation
#
# The product table contains the global data for any given product. 
# It has associations to attachments, tags and skus.
# More detailed information and different product variations are maintained within the Sku table.

# == Schema Information
#
# Table name: products
#
#  id                       :integer          not null, primary key
#  part_number              :string      
#  name                     :string(255)
#  description              :text
#  short_description        :text
#  meta_description         :string(255)
#  weighting                :integer 
#  sku                      :string(255)
#  featured                 :boolean 
#  active                   :boolean          default(true)
#  category_id              :integer    
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Product < ActiveRecord::Base

  attr_accessible :name, :meta_description, :description, :weighting, :sku, :part_number, 
  :accessory_ids, :attachments_attributes, :tags_attributes, :skus_attributes, :category_id, :featured,
  :short_description, :related_ids, :single

  validates :name, :meta_description, :description, 
  :part_number, :sku, :weighting,                             :presence => true
  validates :part_number, :sku, :name,                        :uniqueness => { :scope => :active }
  validates :name, :meta_description,                         :length => {:minimum => 10, :message => :too_short }
  validates :description,                                     :length => {:minimum => 20, :message => :too_short }
  validates :skus,                                            :tier => true, :on => :save
  validates :short_description,                               :length => { :maximum => 100, :message => :too_long }                                                         

  has_many :searches
  has_many :skus,                                             :dependent => :delete_all
  has_many :orders,                                           :through => :skus
  has_many :carts,                                            :through => :skus
  has_many :taggings,                                         :dependent => :delete_all
  has_many :tags,                                             :through => :taggings, :dependent => :delete_all
  has_many :attachments,                                      as: :attachable, :dependent => :delete_all
  has_many :accessorisations,                                 :dependent => :delete_all
  has_many :accessories,                                      :through => :accessorisations
  has_and_belongs_to_many :related,                           class_name: "Product", 
                                                              join_table: :related_products, 
                                                              foreign_key: :product_id, 
                                                              association_foreign_key: :related_id
  belongs_to :category

  before_save :single_product

  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :skus

  searchkick word_start: [:name, :sku, :tags], conversions: "conversions"

  default_scope order('weighting DESC')

  extend FriendlyId
  friendly_id :name, use: :slugged

  def search_data
    {
      name: name,
      conversions: searches.group("query").count
    }
  end

  def inactivate!
    self.update_column(:active, false)
  end

  def activate!
    self.update_column(:active, true)
  end

  def self.active
    where(['products.active = ?', true])
  end

  def single_product
    if self.single && self.skus.count > 1
      errors.add(:product, "cannot be set as a single product with more than one SKU.")
      return false
    end
  end

end
