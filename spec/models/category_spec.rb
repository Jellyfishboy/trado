require 'rails_helper'

describe Category do

    # ActiveRecord relations
    it { expect(subject).to have_many(:products) }
    it { expect(subject).to have_many(:skus).through(:products) }

    #Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:sorting) }
    it { expect(subject).to validate_presence_of(:page_title) }
    it { expect(subject).to validate_presence_of(:meta_description) }

    it { expect(subject).to validate_numericality_of(:sorting).is_greater_than_or_equal_to(0).only_integer } 

    it { expect(subject).to validate_uniqueness_of(:name) }

    it { expect(subject).to ensure_length_of(:page_title).is_at_most(70) }
    it { expect(subject).to ensure_length_of(:meta_description).is_at_most(150) }

    describe "Listing all categories" do
        let!(:category_1) { create(:category) }
        let!(:category_2) { create(:category, active: false) }
        let!(:category_3) { create(:category) }

        it "should return an array of 'active' categories" do
            expect(Category.active).to match_array([category_1, category_3])
        end
    end

    describe "Default scope" do
        let!(:category_1) { create(:category, sorting: 2) }
        let!(:category_2) { create(:category, sorting: 0) }
        let!(:category_3) { create(:category, sorting: 1) }

        it "should return an array of categories ordered by ascending sorting value" do
            expect(Category.last(3)).to match_array([category_2, category_3, category_1])
        end
    end
    
end