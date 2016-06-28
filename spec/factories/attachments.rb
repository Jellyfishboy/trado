# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_record  :boolean          default(FALSE)
#

FactoryGirl.define do
    factory :attachment do
      file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')) }
      default_record { false }

      factory :png_attachment do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.png')) }
      end

      factory :gif_attachment do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.gif')) }
      end

      factory :pdf_attachment do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/base.pdf')) }
      end

      factory :product_attachment do
        association :attachable, factory: :product
      end

      factory :store_setting_attachment do
        association :attachable, factory: :store_setting
      end

      factory :user_attachment do
        association :attachable, factory: :user
      end
    end
end
