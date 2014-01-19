# Shipping Documentation
#
# The shipping table contains a list of available shipping methods, each with a description and price. 
# These are then assigned a tier value, in order to determine the correct shipping method for the dimensions of the product/order.

# == Schema Information
#
# Table name: shippings
#
#  id             :integer          not null, primary key
#  name           :string(255)          
#  price          :decimal          precision(8), scale(2)
#  description    :text          
#  active         :boolean          default(true)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Shipping < ActiveRecord::Base

  attr_accessible :name, :price, :description, :active, :country_ids

  has_many :tiereds,                                    :dependent => :delete_all
  has_many :tiers,                                      :through => :tiereds
  has_many :destinations,                               :dependent => :delete_all
  has_many :countries,                                  :through => :destinations
  has_many :orders,                                     :dependent => :restrict

  validates :name, :price, :description,                :presence => true
  validates :name,                                      :uniqueness => true, :length => {:minimum => 10, :message => :too_short}
  validates :description,                               :length => { :maximum => 100, :message => :too_long }
  validates :price,                                     :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/ }


  def inactivate!
      self.active = false
      save!
  end

  def self.active
    where(['shippings.active = ?', true])
  end

end
