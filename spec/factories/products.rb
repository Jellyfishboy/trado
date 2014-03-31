FactoryGirl.define do
    factory :product do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| "GA#{n}" }
        featured false
        active false
        sequence(:weighting) { |n| n }
        single false

        association :category

        factory :product_skus do 
            after(:create) do |product, evaluator|
                create_list(:sku, 3, product: product)
            end
        end
    end
end