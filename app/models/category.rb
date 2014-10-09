# Category Documentation
#
# The categories table defines different types of products throughout the store.

# == Schema Information
#
# Table name: categories
#
#  id                           :integer            not null, primary key
#  name                         :string(255)      
#  description                  :text             
#  active                       :boolean            default(false)
#  slug                         :string(255)
#  sorting                      :integer            default(0)
#  page_title                   :string(255)
#  meta_description             :string(255)
#  created_at                   :datetime           not null
#  updated_at                   :datetime           not null
#
class Category < ActiveRecord::Base

  attr_accessible :description, :name, :active, :sorting, :page_title, :meta_description

  has_many :products,                                    dependent: :restrict_with_exception
  has_many :skus,                                        through: :products
  has_many :attribute_types,                             through: :skus

  validates :name,:description, :sorting,
  :page_title, :meta_description,                        presence: true
  validates :name,                                       uniqueness: true
  validates :sorting,                                    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :page_title,                                                      length: { maximum: 70, message: :too_long }
  validates :meta_description,                                                length: { maximum: 150, message: :too_long }

  default_scope { order(sorting: :asc) }
  include ActiveScope

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

end
