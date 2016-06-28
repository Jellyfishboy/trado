# == Schema Information
#
# Table name: destinations
#
#  id                  :integer          not null, primary key
#  delivery_service_id :integer
#  country_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
    factory :destination do
        association :country
        association :delivery_service
    end
end
