# == Schema Information
#
# Table name: order_item_accessories
#
#  id            :integer          not null, primary key
#  order_item_id :integer
#  price         :decimal(10, )
#  quantity      :integer
#  accessory_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe OrderItemAccessory do
  
    # ActiveRecord relations
    it { expect(subject).to belong_to(:order_item) }
    it { expect(subject).to belong_to(:accessory) }

end
