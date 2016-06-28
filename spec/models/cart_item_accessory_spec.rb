# == Schema Information
#
# Table name: cart_item_accessories
#
#  id           :integer          not null, primary key
#  cart_item_id :integer
#  price        :decimal(8, 2)
#  quantity     :integer          default(1)
#  accessory_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe CartItemAccessory do
  
    # Activerecord relations
    it { expect(subject).to belong_to(:cart_item) }
    it { expect(subject).to belong_to(:accessory) }

end
