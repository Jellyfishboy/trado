class Destination < ActiveRecord::Base
  attr_accessible :country_id, :shipping_id
  belongs_to :shipping
  belongs_to :country
end
