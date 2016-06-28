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

    it { expect(subject).to validate_length_of(:page_title).is_at_most(70) }
    it { expect(subject).to validate_length_of(:meta_description).is_at_most(150) }

    describe "Default scope" do
        let!(:page_1) { create(:standard_page, sorting: 2) }
        let!(:page_2) { create(:standard_page, sorting: 0) }
        let!(:page_3) { create(:standard_page, sorting: 1) }

        it "should return an array of pages ordered by ascending sorting value" do
            expect(Page.last(3)).to match_array([page_2, page_3, page_1])
        end
    end
end
