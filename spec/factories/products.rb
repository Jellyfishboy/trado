FactoryGirl.define do
    factory :product do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| n }
        featured { false }
        active { false }
        sequence(:weighting) { |n| n }
        single { false }

        association :category

        after(:create) do |product, evaluator|
            create(:product_attachment, attachable: product)
        end

        factory :product_sku do
            after(:create) do |product, evaluator|
                create(:sku, product: product, code: '55', active: true)
            end

            factory :multiple_attachment_product do
                after(:create) do |product, evaluator|
                    create(:product_attachment, attachable: product)
                end
            end

            factory :tags_with_product do
                tags { [create(:tag, name: 'tag #1'), create(:tag, name: 'tag #2'), create(:tag, name: 'tag #3')] }
            end

            factory :product_accessory do
                accessories { [create(:accessory)] }
            end
        end

        factory :product_skus do 
            after(:create) do |product, evaluator|
                create_list(:sku, 3, product: product, active: true)
            end
        end

        factory :build_product_skus do
            skus { build_list(:sku, 3, active: true) }
        end

        factory :product_sku_stock_count do
            after(:create) do |product, evaluator|
                create(:sku, product: product, stock: 10, active: true)
            end
        end

        factory :notified_product do
            after(:create) do |product, evaluator|
                create(:sku_in_stock, product: product)
            end
        end

        factory :invalid_product do
            name { nil }
        end

        # Factories for stock_spec:automated stock warning level
        factory :stock_warning_product_1 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 5, stock_warning_level: 10).save(validate: false)
            end
        end
        factory :stock_warning_product_2 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 20, stock_warning_level: 5).save(validate: false)
            end
        end
        factory :stock_warning_product_3 do
            after(:create) do |product, evaluator|
                build(:sku, product: product, stock: 7, stock_warning_level: 15).save(validate: false)
            end
        end
    end
end