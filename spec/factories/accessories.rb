# == Schema Information
#
# Table name: accessories
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  part_number :integer
#  price       :decimal(8, 2)
#  weight      :decimal(8, 2)
#  cost_value  :decimal(8, 2)
#  active      :boolean          default(TRUE)
#

FactoryGirl.define do 
    factory :accessory do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        sequence(:part_number) { |n| n }
        sequence(:price) { |n| n }
        sequence(:weight) { |n| n }
        sequence(:cost_value) { |n| n }
        active { true }
        
        factory :invalid_accessory do
            name nil
        end
    end
end
