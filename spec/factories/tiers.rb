FactoryGirl.define do
    factory :tier do
        sequence(:length_start) { |n| n }
        sequence(:length_end) { |n| n }
        sequence(:weight_start) { |n| n }
        sequence(:weight_end) { |n| n }
        sequence(:thickness_start) { |n| n }
        sequence(:thickness_end) { |n| n }

        factory :invalid_tier do
            length_start nil
        end

        factory :tier_with_shippings do
            length_start { 0 }
            weight_end { 1 }
            shippings { [create(:shipping, name: 'Royal Mail 1st class', active: true),create(:shipping, name: '48H Parcelforce', active: true)] }
        end
    end
end