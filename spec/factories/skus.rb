FactoryGirl.define do
    factory :sku do
        code { |n| "5#{n}" }
        sequence(:cost_value) { |n| n }
        sequence(:price) { |n| n }
        stock { 30 }
        stock_warning_level { 5 }
        sequence(:length) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:thickness) { |n| n }
        sequence(:attribute_value) { |n| n }
        active { false }

        association :attribute_type
        association :product

        # skip after_create :create_stock_adjustment
        after(:build) { |sku| sku.class.skip_callback(:create, :after, :create_stock_adjustment) }

        # initialize after_create :create_stock_adjustment
        factory :sku_after_stock_adjustment do
            after(:create) { |sku| sku.send(:create_stock_adjustment) }
        end

        factory :sku_in_stock do
            after(:create) do |sku, evaluator|
                create(:sku_notification, notifiable: sku)
            end
        end

        factory :cart_item_sku do
            after(:create) do |sku, evaluator|
                create(:cart_item, quantity: 5, sku: sku)
            end
        end

        factory :invalid_sku do
            code { nil }
        end
    end
end