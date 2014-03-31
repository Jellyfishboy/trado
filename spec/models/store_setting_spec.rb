require 'spec_helper'

describe StoreSetting do

    # ActiveRecord associations
    it { expect(subject).to belong_to(:user) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:tax_name) }
    it { expect(subject).to validate_presence_of(:currency) }
end
