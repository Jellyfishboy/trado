# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Permission do

    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to belong_to(:role) }
end
