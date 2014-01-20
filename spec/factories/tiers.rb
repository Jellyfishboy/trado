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
    end
end