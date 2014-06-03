FactoryGirl.define do
  factory :zone do
    name { Faker::Lorem.word }

    factory :zone_with_countries do
        name { 'EU' }
        countries { [create(:country, name: 'United Kingdom'),create(:country, name: 'Jamaica')] }
    end
  end
end
