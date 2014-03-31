require 'spec_helper'

describe CountryTax do
    
    # ActiveRecord relations
    it { expect(subject).to belong_to(:country) }
    it { expect(subject).to belong_to(:tax_rate) }

end
