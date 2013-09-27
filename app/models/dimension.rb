class Dimension < ActiveRecord::Base
  attr_accessible :size, :weight
  has_many :dimensionals, :dependent => :destroy
  belongs_to :product
end
