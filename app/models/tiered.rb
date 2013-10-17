class Tiered < ActiveRecord::Base
  attr_accessible :shipping_id, :tier_id
  belongs_to :shipping
  belongs_to :tier
end
