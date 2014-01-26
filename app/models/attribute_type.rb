# AttributeType Documentation
#
# The attribute type table allows the administrator to defined attribute types for their different SKUs, e.g. Weight, Color, Size, Length etc.

# == Schema Information
#
# Table name: attribute_types
#
#  id             :integer          not null, primary key
#  name           :string(255)      
#  measurement    :string(255)      
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class AttributeType < ActiveRecord::Base
  attr_accessible :measurement, :name

  has_many :skus,       :dependent => :restrict 

  validates :name,      :presence => true

end
