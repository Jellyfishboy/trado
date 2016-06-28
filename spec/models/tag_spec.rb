# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Tag do

    # ActiveRecord relations
    it { expect(subject).to have_many(:taggings).dependent(:destroy) }
    it { expect(subject).to have_many(:products).through(:taggings) }

    describe "When adding tag records from the comma separated string" do
        let(:product) { create(:product) }
        let(:tags) { "product,accessory,new tag,hello" }
        let(:generate_tags) { Tag.add(tags, product.id) }

        before(:each) do
            unless RSpec.current_example.metadata[:skip_before]
                generate_tags
            end
        end

        it "should increase the number of Tag records", skip_before: true do
            expect{
                generate_tags
            }.to change(Tag, :count).by(4)
        end

        it "should have the correct product id for the tag" do
            expect(Tag.last.products.first.id).to eq product.id
        end

        it "should have the correct tag name" do
            expect(Tag.last.name).to eq 'hello'
        end
    end

    describe "When deleting tag records from the associated product" do

        context "if the comma separated value is empty" do
            let(:product) { create(:tags_with_product) }
            let(:empty_tags) { "" }

            it "should delete all tag records associated with the product" do
                Tag.del(empty_tags, product.id)
                expect(product.tags.count).to eq 0
            end
        end

        context "if the comma separated value is not empty" do
            let(:product) { create(:tags_with_product) }
            let(:partial_tags) { "tag #3" }

            it "should remove only tag records not present in the comma separated string" do
                Tag.del(partial_tags, product.id)
                product.reload
                expect(product.tags.count).to eq 1
                expect(product.tags.first.name).to eq 'tag #3'
            end
        end
    end
end
