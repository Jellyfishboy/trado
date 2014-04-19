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
  
  has_many :country_taxes,                      class_name: 'CountryTax', :dependent => :delete_all
  has_many :countries,                          :through => :country_taxes                  

  validates :name, :rate,                       :presence => true
  validates :name,                              :uniqueness => true, :length => {:minimum => 5, :message => :too_short }
  validates :rate,                              :numericality => { :less_than_or_equal_to => 100, :greater_than_or_equal_to => 0.1 }

  after_save :reset_tax
  
  # Resets the tax rate Store library method after saving a tax rate record as the tax rate is stored as a global variable
  #
  # @return [nil]
  def reset_tax
    Store::reset_tax_rate
  end
  
end
