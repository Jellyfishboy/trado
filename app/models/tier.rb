class Tier < ActiveRecord::Base
  attr_accessible :length_end, :length_start, :thickness_end, :thickness_start, :weight_end, :weight_start
  has_many :tiereds
  has_many :shippings, :through => :tiereds
end
