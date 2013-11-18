class Tagging < ActiveRecord::Base
  attr_accessible :product_id, :tag_id
  belongs_to :product, :dependent => :destroy
  belongs_to :tag, :dependent => :destroy
end
