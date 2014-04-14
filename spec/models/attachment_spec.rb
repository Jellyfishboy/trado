require 'spec_helper'

describe Attachment do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:attachable) }

    # Validations
    it { expect(subject).to validate_presence_of(:file) }

    it { expect(create(:attachment)).to allow_value(".jpg").for(:file) }
    it { expect(create(:png_attachment)).to allow_value(".png").for(:file) }
    it { expect(create(:gif_attachment)).to allow_value(".gif").for(:file) }

end