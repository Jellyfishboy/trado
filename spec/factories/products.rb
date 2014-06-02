FactoryGirl.define do
    factory :product do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| n }
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

        factory :product_sku do
            after(:create) do |product, evaluator|
                create(:sku, product: product, code: '55')
            end
        end

        factory :notified_product do
            after(:create) do |product, evaluator|
                create(:sku_in_stock, product: product)
                create(:product_attachment, attachable: product)
            end
        end

        # Factories for stock_spec:automated stock warning level
        factory :stock_warning_product_1 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 5, stock_warning_level: 10).save(validate: false)
                create(:product_attachment, attachable: product)
            end
        end
        factory :stock_warning_product_2 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 20, stock_warning_level: 5).save(validate: false)
                create(:product_attachment, attachable: product)
            end
        end
        factory :stock_warning_product_3 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 7, stock_warning_level: 15).save(validate: false)
                create(:product_attachment, attachable: product)
            end
        end
    end
end