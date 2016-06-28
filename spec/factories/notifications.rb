# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  email           :string
#  notifiable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sent            :boolean          default(FALSE)
#  sent_at         :datetime
#  notifiable_type :string
#

FactoryGirl.define do
    factory :notification do
        email { Faker::Internet.email }
        sent false
        sent_at nil

        factory :sent_notification do
            sent true
            sequence(:sent_at) { |d| Time.zone.today - d.days }
        end
        
        factory :sku_notification do
            association :notifiable, :factory => :sku
        end

        factory :user_notification do
            association :notifiable, :factory => :user
        end
    end
end
