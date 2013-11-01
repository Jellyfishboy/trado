class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :price, :cost_value
  has_many :dimensionals, :dependent => :destroy
  belongs_to :product
end
