require 'spec_helper'

describe Order do

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_one(:transaction).dependent(:destroy) }
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:ship_address).class_name('Address') }
    it { expect(subject).to belong_to(:bill_address).class_name('Address') }

    context "If current order status is at shipping" do
        before { subject.stub(:active_or_shipping?) { true } }
        it { expect(subject).to validate_presence_of(:email).with_message('is required') }
        it { expect(subject).to validate_presence_of(:shipping_id).with_message('Shipping option is required') }
        it { expect(subject).to allow_value("test@test.com").for(:email) }
        it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    end
end
