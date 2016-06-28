# == Schema Information
#
# Table name: accessorisations
#
#  id           :integer          not null, primary key
#  accessory_id :integer
#  product_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Accessorisation do
  
    # ActiveRecord relations
    it { expect(subject).to belong_to(:accessory) }
    it { expect(subject).to belong_to(:product) }

end
