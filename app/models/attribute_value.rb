class AttributeValue < ActiveRecord::Base
  attr_accessible :sku_id, :value, :attribute_type_id
  validates :value, :attribute_type_id, :presence => true
  validates :value, :uniqueness => {:scope => :sku_id}
  belongs_to :attribute_type
  belongs_to :sku
end
