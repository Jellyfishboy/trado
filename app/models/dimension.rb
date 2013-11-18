class Dimension < ActiveRecord::Base
  attr_accessible :length, :weight, :thickness, :price, :cost_value
  has_many :dimensionals, :dependent => :delete_all
  belongs_to :product, :dependent => :destroy
end
