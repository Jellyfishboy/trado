# Accessorisation Documentation
#
# The accessorisation table is a HABTM relationship handler between the accessories and products tables.

# == Schema Information
#
# Table name: accessorisations
#
#  id               :integer          not null, primary key
#  accessory_id     :integer
#  product_id       :integer          
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Accessorisation < ActiveRecord::Base

  attr_accessible :accessory_id, :product_id

  belongs_to :accessory
  belongs_to :product
  
end
