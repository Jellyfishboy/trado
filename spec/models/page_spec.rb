require 'rails_helper'

describe Page do

    # Validations
    it { expect(subject).to validate_presence_of(:title) }
    it { expect(subject).to validate_presence_of(:menu_title) }
    it { expect(subject).to validate_presence_of(:content) }
    it { expect(subject).to validate_presence_of(:page_title) }
    it { expect(subject).to validate_presence_of(:meta_description) }

    it { expect(subject).to validate_uniqueness_of(:title) }
    it { expect(subject).to validate_uniqueness_of(:menu_title) }
    it { expect(subject).to validate_uniqueness_of(:slug) }

    it { expect(subject).to ensure_length_of(:page_title).is_at_most(70) }
    it { expect(subject).to ensure_length_of(:meta_description).is_at_most(150) }

    describe "Default scope" do
        let!(:page_1) { create(:standard_page, title: 'zed') }
        let!(:page_2) { create(:standard_page, title: 'adam') }
        let!(:page_3) { create(:standard_page, title: 'harold') }

        it "should return an array of pages ordered by ascending title value" do
            expect(Page.last(3)).to match_array([page_2, page_3, page_1])
        end
    end
end
