class Category < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :categorisations, :dependent => :destroy
  has_many :products, :through => :categorisations

end
