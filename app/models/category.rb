# Category Documentation
#
# The categories table defines different types of products throughout the store.

# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string(255)      
#  description    :text             
#  visible        :boolean          default(false)
#  slug           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Category < ActiveRecord::Base

  attr_accessible :description, :name, :visible

  has_many :products

  validates :name,:description,         :presence => true
  validates :name,                      :uniqueness => true

  extend FriendlyId
  friendly_id :name, use: :slugged

end
