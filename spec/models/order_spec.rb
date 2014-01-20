require 'spec_helper'

describe Order do

    # ActiveRecord relations
    it { expect(subject).to have_many(:order_items).dependent(:delete_all) }
    it { expect(subject).to have_one(:transaction).dependent(:destroy) }
    it { expect(subject).to belong_to(:shipping) }
    it { expect(subject).to belong_to(:ship_address).class_name('Address') }
    it { expect(subject).to belong_to(:bill_address).class_name('Address') }
end
