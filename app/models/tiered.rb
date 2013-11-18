class Tiered < ActiveRecord::Base
  attr_accessible :shipping_id, :tier_id
  belongs_to :shipping, :dependent => :destroy
  belongs_to :tier, :dependent => :destroy
end
