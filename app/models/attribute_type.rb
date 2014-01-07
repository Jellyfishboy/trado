class AttributeType < ActiveRecord::Base
  attr_accessible :measurement, :name
  validates :name, :presence => true
  has_many :attribute_values
end
