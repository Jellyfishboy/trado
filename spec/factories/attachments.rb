FactoryGirl.define do
    factory :attachment do
      file { File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')) }
      description { Faker::Lorem.characters(5) }

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
        association :attachable, :factory => :product
      end
    end
end