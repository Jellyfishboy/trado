# Sku Documentation
#
# The Sku table manages all the product variations. The Sku column value is automatically generated by the product SKU being combined with
# the attribute_value field. Each attribute value is unique within its parent product, and each SKU is unique globally.
# Product table utitlises the Sku table in order to create an easy and scalable database. 

# == Schema Information
#
# Table name: skus
#
#  id                         :integer          not null, primary key
#  sku                        :string(255)      
#  length                     :decimal          precision(8), scale(2) 
#  weight                     :decimal          precision(8), scale(2) 
#  thickness                  :decimal          precision(8), scale(2) 
#  attribute_value            :string(255) 
#  attribute_type_id          :integer 
#  stock                      :integer 
#  stock_warning_level        :integer 
#  cost_value                 :decimal          precision(8), scale(2) 
#  price                      :decimal          precision(8), scale(2) 
#  product_id                 :integer 
#  active                     :boolean          default(true)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class Sku < ActiveRecord::Base
  
  attr_accessible :cost_value, :price, :sku, :stock, :stock_warning_level, :length, 
  :weight, :thickness, :product_id, :attribute_value, :attribute_type_id, :accessory_id
  
  validates :price, :cost_value, :length, 
  :weight, :thickness, :attribute_value, 
  :attribute_type_id,                                         :presence => true
  validates :price, :cost_value,                              :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }
  validates :length, :weight, :thickness,                     :numericality => { :greater_than_or_equal_to => 0 }
  validates :stock, :stock_warning_level,                     :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validate :stock_values,                                     :on => :create
  validates :attribute_value,                                 :uniqueness => { :scope => [:product_id, :active] }
  validates :sku,                                             :uniqueness => { :scope => [:product_id, :active] }, :presence => true, :if => :new_sku?
  validates :attribute_value, :attribute_type_id,             :presence => true
  
  belongs_to :product
  belongs_to :attribute_type
  has_many :cart_items
  has_many :carts,                                  :through => :cart_items
  has_many :order_items,                            :dependent => :restrict
  has_many :orders,                                 :through => :order_items, :dependent => :restrict
  has_many :notifications,                          as: :notifiable, :dependent => :delete_all
  has_many :stock_levels,                           :dependent => :delete_all

  # Validation check to ensure the stock value is higher than the stock warning level value when creating a new SKU
  #
  # @return [boolean]
  def stock_values
    if self.stock && self.stock_warning_level && self.stock <= self.stock_warning_level
      errors.add(:sku, "stock warning level value must not be below your stock count.")
      return false
    end
  end

  # Sets the related record's active field as false
  #
  # @return [object]
  def inactivate!
    self.update_column(:active, false)
  end

  # Sets the related record's active field as true
  #
  # @return [object]
  def activate!
    self.update_column(:active, true)
  end

  # Grabs an array of records which have their active field set to true
  #
  # @return [array]
  def self.active
    where(['skus.active = ?', true])
  end

  # Validate wether the current record is new
  #
  # @return [boolean]
  def new_sku?
    return true if self.product.nil?
  end

  # Validates the attribute_value and attribute_type_id if there is only one SKU associated with product
  # The standard self.skus.count is performed using the record ID, which none of the SKUs currently have
  #
  # @return [boolean]
  def single_sku?
    return true if self.product.skus.map { |s| s.active }.count == 1
  end

  # Joins the parent product SKU and the current SKU with a hyphen
  #
  # @return [string]
  def full_sku
    [product.sku, sku].join('-')
  end

end
