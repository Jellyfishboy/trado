class Tagging < ActiveRecord::Base
  attr_accessible :product_id, :tag_id
  belongs_to :product
  belongs_to :tag
end
