FactoryGirl.define do
  factory :country_taxes, :class => 'CountryTax' do
    
    association :country
    association :tax_rate
  end
end
