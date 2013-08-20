class Dimension < ActiveRecord::Base
  attr_accessible :product_id, :size, :weight, :shipping_id
  belongs_to :product
  has_many :shippings
  accepts_nested_attributes_for :shippings
end
