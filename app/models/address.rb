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
#  legacy_country   :string
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

  attr_accessible :active, :address, :city, :company, :county, :addressable_id,
  :addressable_type, :default, :first_name, :last_name, :postcode, :telephone, :order_id, :address_country_attributes

  belongs_to :order
  belongs_to :addressable,                                          polymorphic: true

  has_one :address_country,                                         dependent: :destroy
  has_one :country,                                                 through: :address_country

  validates :first_name, :last_name, 
  :address, :city, :postcode,                                       presence: true

  accepts_nested_attributes_for :address_country

  after_initialize :build_country_association

  # Combines the first and last name of an address
  #
  # @return [String] first and last name concatenated
  def full_name
    [first_name, last_name].join(' ')
  end

  def legacy_country_match?
    country.present? && country.try(:name) == legacy_country ? true : false
  end

  def build_country_association
    build_address_country if new_record? && address_country.nil?
  end

  def full_address
    # TODO: Clean this up and move to paypal module
    {
      name: full_name,
      address1: address,
      city: city,
      zip: postcode,
      state: county,
      country: country.alpha_two_code,
      telephone: telephone
    }
  end
end
