require 'spec_helper'

describe Attachment do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:attachable) }

    # Validations
    before { subject.stub(:not_setting_attachment?) { true } }
    it { expect(subject).to validate_presence_of(:file) }

    it { expect(create(:attachment)).to allow_value(".jpg").for(:file) }
    it { expect(create(:png_attachment)).to allow_value(".png").for(:file) }
    it { expect(create(:gif_attachment)).to allow_value(".gif").for(:file) }

    describe "When saving an attachment" do

        it "should call set_default_attachment before a save" do
            Attachment._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:set_default_attachment).should == true
        end

        context "if the default_record property has been updated and set to true" do
            let!(:attachment_1) { create(:product_attachment, default_record: true) }
            let!(:attachment_2) { create(:product_attachment) }
            let!(:attachment_3) { create(:product_attachment) }
            before(:each) do
                attachment_2.update_attributes(:default_record => true)
            end

            it "should update all other records default_record property to false" do
                attachment_1.reload
                expect(attachment_1.default_record).to eq false
                expect(attachment_2.default_record).to eq true
                expect(attachment_3.default_record).to eq false
            end
        end

        context "if the default_record property is not updated" do
            let!(:attachment_1) { create(:product_attachment, default_record: true) }
            let!(:attachment_2) { create(:product_attachment) }
            let!(:attachment_3) { create(:product_attachment) }
            before(:each) do
                attachment_2.update_attributes(:attachable_type => 'Sku')
            end

            it "should not do anything" do
                expect(attachment_1.default_record).to eq true
                expect(attachment_2.default_record).to eq false
                expect(attachment_3.default_record).to eq false
            end
        end
    end

    describe "When calculating the type of an attachment" do
        let(:setting) { create(:store_setting_attachment) }
        let(:user) { create(:user_attachment) }
        let(:product) { create(:product_attachment) }

        context "if the type is StoreSetting" do

            it "should return false" do
                expect(setting.not_setting_attachment?).to be_false
            end
        end

        context "if the type is User" do

            it "should return false" do
                expect(user.not_setting_attachment?).to be_false
            end
        end

        context "if the type is Product" do

            it "should return true" do
                expect(product.not_setting_attachment?).to be_true
            end
        end
    end
end