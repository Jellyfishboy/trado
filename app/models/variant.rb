class Variant < ActiveRecord::Base
  attr_accessible :measurement, :type
  validates :type, :presence => true
  has_many :variant_values, :as => :value
end
