class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness
  has_many :dimensionals, :dependent => :destroy
  belongs_to :product
end
