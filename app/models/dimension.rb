class Dimension < ActiveRecord::Base
  attr_accessible :size, :weight
  has_many :dimensionals
  belongs_to :product
end
