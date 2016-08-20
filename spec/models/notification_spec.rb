# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  email           :string
#  notifiable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sent            :boolean          default(FALSE)
#  sent_at         :datetime
#  notifiable_type :string
#

require 'rails_helper'

describe Notification do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:notifiable) }

    # Validations
    it { expect(subject).to validate_presence_of(:email).with_message('is required') }

    it { expect(subject).to allow_value("test@test.com").for(:email) }
    it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }

    it { expect(create(:sku_notification)).to validate_uniqueness_of(:email).scoped_to([:notifiable_id, :notifiable_type, :sent_at]).with_message('notification has already been created.') }

    context 'skus and users can be associated to a notification' do
      let(:duplicate_id)      { 1000000009 }
      let(:sku)               { FactoryGirl.create(:sku, id: duplicate_id) }
      let(:user)              { FactoryGirl.create(:user, id: duplicate_id) }
      let(:sku_notification)  { FactoryGirl.create(:sku_notification, email: 'qwerty21@gmail.com', notifiable: sku) }
      let(:user_notification) { FactoryGirl.build(:user_notification, email: 'qwerty21@gmail.com', notifiable: user) }

      it 'should allow different models to be associated' do
        expect(sku_notification.valid?).to be true
        expect(user_notification.valid?).to be true
        expect(user_notification.save).to be true
      end
    end

    context 'skus and users can be associated to a notification' do
      let(:user)              { FactoryGirl.create(:user) }
      let(:notification)      { FactoryGirl.build(:user_notification, email: 'qwerty22@gmail.com', notifiable: user) }
      let(:user_notification) { FactoryGirl.create(:user_notification, email: 'qwerty22@gmail.com', notifiable: user, sent_at: 2.years.ago, created_at: 3.years.ago) }

      it 'should allow a second association if the first was sent years ago' do
        expect(user_notification.valid?).to be true
        expect(notification.valid?).to be true
        expect(notification.save).to be true
      end
    end
end
