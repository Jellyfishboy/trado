require 'rails_helper'

describe Transaction do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }

    # Validations
    it { expect(subject).to ensure_inclusion_of(:payment_status).in_array(['Completed', 'Pending']).with_message('Payment status must be set for the order.') }

end