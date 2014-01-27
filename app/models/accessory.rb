# Accessory Documentation
#
# 

# == Schema Information
#
# Table name: accessories
#
#  id             :integer          not null, primary key
#  name           :string(255)      
#  part_number    :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Accessory < ActiveRecord::Base

  attr_accessible :name, :part_number, :sku_attributes

  has_one :sku,                                     :dependent => :destroy
  has_many :orders,                                 :through => :sku
  has_many :carts,                                  :through => :sku

  validates :name, :part_number,                    :presence => true, :uniqueness => true     
  validates_numericality_of :part_number,           :only_integer => true, :greater_than_or_equal_to => 1

  accepts_nested_attributes_for :sku

end
