FactoryGirl.define do
  factory :zone do
    name { Faker::Lorem.word }

    factory :zone_with_countries do
        name { 'EU' }
        after(:create) do |zone, evaluator|
            zone.countries << create(:country, name: 'United Kingdom')
            zone.countries << create(:country, name: 'Jamaica')
        end
    end
  end
end
