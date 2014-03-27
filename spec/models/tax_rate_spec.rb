require 'spec_helper'

describe TaxRate do
    
    # ActiveRecord relations
    it { expect(subject).to have_many(:country_taxes).class_name('CountryTax').dependent(:delete_all) }
    it { expect(subject).to have_many(:countries).through(:country_taxes) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:rate) }
    it { expect(subject).to validate_uniqueness_of(:name) }
    it { expect(subject).to validate_numericality_of(:rate).is_greater_than_or_equal_to(0.1) }
    it { expect(subject).to validate_numericality_of(:rate).is_less_than_or_equal_to(100) }
    it { expect(subject).to ensure_length_of(:name).is_at_least(5) }

end
