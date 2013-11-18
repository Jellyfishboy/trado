class Tier < ActiveRecord::Base
  attr_accessible :length_end, :length_start, :thickness_end, :thickness_start, :weight_end, :weight_start, :shipping_ids
  has_many :tiereds, :dependent => :delete_all
  has_many :shippings, :through => :tiereds
  validates :length_end, :length_start, :thickness_end, :thickness_start, :weight_end, :weight_start, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
end
