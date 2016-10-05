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

FactoryGirl.define do
    factory :address do
        active false
        default false
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        company { Faker::Company.name }
        address { Faker::Address.street_address }
        city { Faker::Address.city }
        county { Faker::Address.state }
        postcode { Faker::Address.zip_code }
        telephone { Faker::PhoneNumber.phone_number }


        after(:build) do |address|
            address.address_country = build(:address_country, address: address)
        end
    end
end
