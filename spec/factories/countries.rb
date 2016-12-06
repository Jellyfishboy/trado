# == Schema Information
#
# Table name: countries
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  popular        :boolean          default(FALSE)
#  alpha_two_code :string
#

FactoryGirl.define do
    factory :country do
        sequence(:name)  { |n| "#{Faker::Address.country}#{n}" }
        sequence(:alpha_two_code) { |n| "#{n}#{Faker::Address.country_code}" }
        popular { false }

        factory :invalid_country do
            name nil
        end
    end
end
