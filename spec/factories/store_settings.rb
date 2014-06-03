FactoryGirl.define do
    factory :store_setting do
        name { Faker::Lorem.word }
        email { Faker::Internet.email }
        currency { Faker::Lorem.characters(1) }
        tax_name { Faker::Lorem.word }
        sequence(:tax_rate) { |n| n }
        tax_breakdown { false }
        ga_code { Faker::Lorem.characters(8) }
        ga_active { true }
        cheque { false }
        bank_transfer { false }

        factory :attached_store_setting do
            after(:create) do |store_setting, evaluator|
                create(:store_setting_attachment, attachable: store_setting)
            end
        end
    end
end
