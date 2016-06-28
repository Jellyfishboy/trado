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

require 'rails_helper'

describe Attachment do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:attachable) }

    # Validations
    context "When the attachment is not related to StoreSetting or User" do
        before { subject.stub(:not_setting_attachment?) { true } }
        it { expect(subject).to validate_presence_of(:file) }
    end

    it { expect(create(:attachment)).to allow_value(".jpg").for(:file) }
    it { expect(create(:png_attachment)).to allow_value(".png").for(:file) }
    it { expect(create(:gif_attachment)).to allow_value(".gif").for(:file) }

    describe "When updating an attachment" do

        it "should call the set_default method after save" do
            Attachment._save_callbacks.select { |cb| cb.kind.eql?(:after) }.map(&:raw_filter).include?(:set_default).should == true
        end
        let!(:product) { create(:product) }
        let(:attachment_1) { create(:attachment, attachable: product, default_record: true) }
        let!(:attachment_2) { create(:attachment, attachable: product, default_record: true) }


        it "should set all other attachments associated to the parent record" do
            expect{
                attachment_1
            }.to change{
                attachment_2.reload
                attachment_2.default_record
            }.from(true).to(false)
        end
    end

    describe "When calculating the type of an attachment" do
        let(:setting) { create(:store_setting_attachment) }
        let(:user) { create(:user_attachment) }
        let(:product) { create(:product_attachment) }

        context "if the type is StoreSetting" do

            it "should return false" do
                expect(setting.not_setting_attachment?).to eq false
            end
        end

        context "if the type is User" do

            it "should return false" do
                expect(user.not_setting_attachment?).to eq false
            end
        end

        context "if the type is Product" do

            it "should return true" do
                expect(product.not_setting_attachment?).to eq true
            end
        end
    end
end
