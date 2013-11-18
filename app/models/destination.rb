class Destination < ActiveRecord::Base
  attr_accessible :country_id, :shipping_id
  belongs_to :shipping, :dependent => :destroy
  belongs_to :country, :dependent => :destroy
end
