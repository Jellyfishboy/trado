# Address Documentation
#
# The address table provides support for handling order and user addresses. 
# It has a polymorphic relation so can be utilised by various models.
# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  company          :string
#  address          :string
#  city             :string
#  county           :string
#  postcode         :string
#  country          :string
#  telephone        :string
#  active           :boolean          default(TRUE)
#  default          :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :integer
#  addressable_type :string
#  order_id         :integer
#

class Address < ActiveRecord::Base

  attr_accessible :active, :address, :city, :company, :country, :county, :addressable_id,
  :addressable_type, :default, :first_name, :last_name, :postcode, :telephone, :order_id

  belongs_to :order
  belongs_to :addressable,                                          polymorphic: true

  validates :first_name, :last_name, 
  :address, :city, :postcode, :country,                             presence: true

  # Combines the first and last name of an address
  #
  # @return [String] first and last name concatenated
  def full_name
    [first_name, last_name].join(' ')
  end

  def full_address
    # TODO: Clean this up and move to paypal module
    cnty = Country.find_by_name(country)
    alpha_two_code = cnty.nil? ? 'GB' : cnty.alpha_two_code
    {
      name: full_name,
      address1: address,
      city: city,
      zip: postcode,
      state: county,
      country: alpha_two_code,
      telephone: telephone
    }
  end
end
