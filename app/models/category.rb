class Category < ActiveRecord::Base
  attr_accessible :description, :name, :visible
  has_many :categorisations, :dependent => :delete_all
  has_many :products, :through => :categorisations

end
