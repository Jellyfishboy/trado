FactoryGirl.define do
  factory :zone do
    sequence(:name) { |n| "#{Faker::Address.country}#{n}" }

    factory :zone_with_country do
        name { 'EU' }
        countries { [create(:country, name: 'United Kingdom'),create(:country, name: 'Jamaica')] }
    end

    factory :invalid_zone do
        name { nil }
    end
  end
end
