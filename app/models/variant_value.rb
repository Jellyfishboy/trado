class VariantValue < ActiveRecord::Base
  attr_accessible :sku_id, :value, :variant_id, :dimension_id
  validates :value, :presence => true
  belongs_to :dimension
  belongs_to :sku
  belongs_to :variant
end
