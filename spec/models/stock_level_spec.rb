require 'spec_helper'

describe StockLevel do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:sku) }

    # Validation
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to validate_presence_of(:adjustment) }
    it { expect(subject).to ensure_length_of(:description).is_at_least(5) }

end
