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

  attr_accessible :name, :part_number, :price, :weight, :cost_value, :active

  has_many :cart_item_accessories
  has_many :carts,                                  :through => :cart_item_accessories
  has_many :order_item_accessories,                 :dependent => :restrict
  has_many :orders,                                 :through => :order_item_accessories, :dependent => :restrict
  has_many :accessorisations,                       :dependent => :delete_all
  has_many :products,                               :through => :accessorisations

  validates :name, :part_number,                    :presence => true, :uniqueness => true     
  validates_numericality_of :part_number,           :only_integer => true, :greater_than_or_equal_to => 1

end
