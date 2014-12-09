FactoryGirl.define do
    factory :sku_variant do
        name { Faker::Lorem.characters(5) }

        association :sku
        association :variant_type
    end
end
