# CountryTax Documentation
#
# The country_tax table is a HABTM relationship handler between the countries and tax_rates tables.

# == Schema Information
#
# Table name: country_taxes
#
#  id                   :integer          not null, primary key
#  country_id           :integer
#  tax_rate_id          :integer          
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class CountryTax < ActiveRecord::Base

  attr_accessible :country_id, :tax_rate_id

  belongs_to :country
  belongs_to :tax_rate

end
