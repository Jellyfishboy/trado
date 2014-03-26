# Product TaxRate
#
# The tax_rate table defines different tax amounts for each country.
# This has a HABTM relationship with countries.

# == Schema Information
#
# Table name: tax_rates
#
#  id                       :integer          not null, primary key
#  name                     :string(255)   
#  rate                     :decimal          precision(8), scale(2)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class TaxRate < ActiveRecord::Base

  attr_accessible :name, :rate, :country_ids
  
  has_many :countries                  

  validates :name, :rate,               :presence => true
  validates :name,                      :uniqueness => true

end
