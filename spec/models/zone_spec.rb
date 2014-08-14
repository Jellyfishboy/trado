require 'rails_helper'

describe Zone do
  
    # ActiveRecord relations
    it { expect(subject).to have_many(:destinations).dependent(:delete_all) }
    it { expect(subject).to have_many(:delivery_services).through(:destinations) }
    it { expect(subject).to have_many(:zonifications).dependent(:delete_all) }
    it { expect(subject).to have_many(:countries).through(:zonifications) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }

    it { expect(subject).to validate_uniqueness_of(:name) }

end
