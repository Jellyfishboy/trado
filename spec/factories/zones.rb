FactoryGirl.define do
  factory :zone do
    name { Faker::Address.country }

    factory :zone_with_countries do
        name { 'EU' }
        countries { [create(:country, name: 'United Kingdom'),create(:country, name: 'Jamaica')] }
    end

    factory :invalid_zone do
        name { nil }
    end
  end
end
