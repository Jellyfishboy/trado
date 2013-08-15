class Category < ActiveRecord::Base
  has_many :products
  attr_accessible :description, :name, :product_id

  def self.names
    all.collect { |category| category.name }
  end #collects all the columns in paytype db by name and assigns to method 'name'
end
