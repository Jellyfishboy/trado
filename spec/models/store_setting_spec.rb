require 'rails_helper'

describe StoreSetting do

    # ActiveRecord associations
    it { expect(subject).to have_one(:attachment).dependent(:destroy) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:tax_name) }
    it { expect(subject).to validate_presence_of(:currency) }
    it { expect(subject).to validate_presence_of(:tax_rate) }
    
end
