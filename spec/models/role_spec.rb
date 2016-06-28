# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string           default("user")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Role do

    # ActiveRecord relations
    it { expect(subject).to have_many(:permissions).dependent(:destroy) }
    it { expect(subject).to have_many(:users).through(:permissions) }
end
