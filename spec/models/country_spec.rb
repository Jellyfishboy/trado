# == Schema Information
#
# Table name: countries
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  popular        :boolean          default(FALSE)
#  alpha_two_code :string
#

require 'rails_helper'

describe Country do

    # ActiveRecord
    it { expect(subject).to have_many(:destinations).dependent(:destroy) }
    it { expect(subject).to have_many(:delivery_services).through(:destinations) }

    # Validations
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_uniqueness_of(:name) }
end
