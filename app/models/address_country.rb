# == Schema Information
#
# Table name: address_countries
#
#  id         :integer          not null, primary key
#  address_id :integer
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AddressCountry < ActiveRecord::Base
    attr_accessible :address_id, :country_id

    belongs_to :address
    belongs_to :country

    validates :address_id,                    uniqueness: { scope: :country_id }
    validates :country_id,                    presence: true
end
