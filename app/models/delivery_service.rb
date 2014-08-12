# DeliveryService Documentation
#
# The delivery_service table contains a list of available delivery services, with detailed service data. 
# A delivery service can have many delivery service prices.

# == Schema Information
#
# Table name: delivery_services
#
#  id                 :integer          not null, primary key
#  name               :string(255)          
#  description        :text          
#  courier_name       :string(255)          
#  active             :boolean          default(true)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class DeliveryService < ActiveRecord::Base
    attr_accessible :name, :description, :courier_name, :active

    has_many :delivery_service_prices

    validates :name, :courier_name,                         presence: true
    validates :description,                                 length: { maximum: 180, message: :too_long }

    default_scope { order(courier_name: :desc) }
end
