require 'rails_helper'

describe ContactMessage do

    # Validations
    it { expect(subject).to validate_presence_of(:name) } 
    it { expect(subject).to validate_presence_of(:email).with_message('is required') } 
    it { expect(subject).to validate_presence_of(:message) }
    it { expect(subject).to ensure_length_of(:message).is_at_most(500) }
    it { expect(subject).to allow_value("test@test.com").for(:email) }
    it { expect(subject).to_not allow_value("test@test").for(:email).with_message(/invalid/) }
    
end