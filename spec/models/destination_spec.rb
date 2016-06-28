# == Schema Information
#
# Table name: destinations
#
#  id                  :integer          not null, primary key
#  delivery_service_id :integer
#  country_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

describe Destination do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:delivery_service) }
    it { expect(subject).to belong_to(:country) }

end
