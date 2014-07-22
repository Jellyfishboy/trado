FactoryGirl.define do
    factory :shipping do
        name { Faker::Lorem.characters(10) }
        sequence(:price) { |n| n }
        description { Faker::Lorem.characters(99) }
        active { false }

        factory :shipping_with_zones do
            name { 'Royal mail 1st class' }
            active { true }
            zones { [create(:zone, name: 'EU'),create(:zone, name: 'Asia')]}
        end

        factory :invalid_shipping do
            name { nil }
        end
    end
end