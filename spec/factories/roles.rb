# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string           default("user")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
    factory :role do
        name { 'user' }
    end
end
