require 'spec_helper'

describe Notification do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:notifiable) }

    #Validations
    it { expect(subject).to validate_presence_of(:email) }

    it { expect(subject).to allow_value("test@test.com").for(:email) }
    it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }

    it { expect(create(:sku_notification)).to validate_uniqueness_of(:email).scoped_to(:notifiable_id).with_message('has already been submitted for this product SKU.') }

end