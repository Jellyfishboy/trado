# Country Documentation
#
# The country table is a list of available countries available to a user when they select their billing and shipping country. 
# It has and belongs to zones and tax_rates.

# == Schema Information
#
# Table name: countries
#
#  id                   :integer          not null, primary key
#  name                 :string(255)     
#  language             :string(255)
#  iso                  :string(255)
#  available            :boolean          default(false)
#  tax_rate_id          :integer  
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Country < ActiveRecord::Base

  attr_accessible :name, :iso, :available, :language

  has_many :zonifications,                      :dependent => :delete_all
  has_many :zones,                              :through => :zonifications
  has_one :country_tax,                         class_name: 'CountryTax', :dependent => :destroy
  has_one :tax,                                 :through => :country_tax, :source => :tax_rate


  validates :name, :iso,                        :uniqueness => true, :presence => true

  after_save :reset_tax

  default_scope order('name ASC')

  # Grabs an array of records which have their available field set to true
  #
  # @return [array]
  def self.available 
    where(['countries.available = ?', true])
  end

  # Resets the tax rate Store library method after saving a country record as the tax rate is stored as a global variable
  # This is only required when a countries available value has been modified
  #
  # @return [nil]
  def reset_tax
    Store::reset_tax_rate
  end

end
