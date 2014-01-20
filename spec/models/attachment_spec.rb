require 'spec_helper'

describe Attachment do

    # Validations
    it { expect(subject).to validate_presence_of(:file) }
    it { expect(subject).to validate_presence_of(:description) }

    it { expect(subject).to ensure_length_of(:description).is_at_least(5) }

    it { expect(create(:attachment)).to allow_value(".jpg").for(:file) }
    it { expect(create(:png_attachment)).to allow_value(".png").for(:file) }
    it { expect(create(:gif_attachment)).to allow_value(".gif").for(:file) }


    

end