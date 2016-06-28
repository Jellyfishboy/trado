# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  title            :string
#  content          :text
#  page_title       :string
#  meta_description :string
#  active           :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  slug             :string
#  template_type    :integer
#  menu_title       :string
#  sorting          :integer          default(0)
#

FactoryGirl.define do
    factory :page do
        title { Faker::Lorem.characters(10) }
        menu_title { Faker::Lorem.characters(5) }
        content { Faker::Lorem.paragraph(3) }
        page_title { Faker::Lorem.characters(20) }
        meta_description { Faker::Lorem.sentence }
        slug { Faker::Lorem.characters(10) }
        active { true }
        sequence(:sorting) { |n| n }

        factory :standard_page do
            template_type { 0 }
        end

        factory :contact_page do
            template_type { 1 }
        end
    end
end
