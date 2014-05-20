# Category Documentation
#
# The categories table defines different types of products throughout the store.

# == Schema Information
#
# Table name: categories
#
#  id                   :integer            not null, primary key
#  name                 :string(255)      
#  description          :text             
#  visible              :boolean            default(false)
#  slug                 :string(255)
#  sorting              :integer            default(0)
#  created_at           :datetime           not null
#  updated_at           :datetime           not null
#
class Category < ActiveRecord::Base

  attr_accessible :description, :name, :visible, :sorting

  has_many :products

  validates :name,:description, :sorting,                :presence => true
  validates :name,                                       :uniqueness => true
  validates :sorting,                                    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  default_scope order('sorting ASC')

  extend FriendlyId
  friendly_id :name, use: :slugged

end
