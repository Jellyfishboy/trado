FactoryGirl.define do
    factory :attachment do
      file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')) }
      description { Faker::Lorem.characters(5) }

      factory :png_image do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')) }
      end

      factory :gif_image do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')) }
      end

      factory :pdf do
        file { File.open(File.join(Rails.root, '/spec/dummy_data/base.pdf')) }
      end

      factory :product_attachment do
        association :attachable, :factory => :product
      end
    end
end