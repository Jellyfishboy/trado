FactoryGirl.define do
    factory :tier do
        length_start { |n| n }
        length_end { |n| n }
        weight_start { |n| n }
        weight_end { |n| n }
        thickness_start { |n| n }
        thickness_end { |n| n }
    end
end