# DeliveryService Documentation
#
# The delivery_service table contains a list of available delivery services, with detailed service data. 
# A delivery service can have many delivery service prices.

# == Schema Information
#
# Table name: delivery_services
#
#  id                             :integer            not null, primary key
#  name                           :string(255)          
#  description                    :text          
#  courier_name                   :string(255)          
#  order_price_minimum            :decimal            precision(8), scale(2), default(0)
#  order_price_maximum            :decimal            precision(8), scale(2)
#  active                         :boolean            default(true)
#  tracking_url                   :string(255)
#  created_at                     :datetime           not null
#  updated_at                     :datetime           not null
#
class DeliveryService < ActiveRecord::Base
    attr_accessible :name, :description, :courier_name, :order_price_minimum, :order_price_maximum, :active, :country_ids, :tracking_url

    has_many :prices,                                       class_name: 'DeliveryServicePrice', dependent: :destroy
    has_many :destinations,                                 dependent: :destroy
    has_many :countries,                                    through: :destinations                                                     
    has_many :orders,                                       through: :prices

    validates :name, :courier_name,                         presence: true
    validates :name,                                        uniqueness: { scope: [:active, :courier_name] }
    validates :description,                                 length: { maximum: 180, message: :too_long }

    default_scope { order(courier_name: :desc) }

    include ActiveScope

    # Returns a string of the courier_name and name attributes concatenated
    #
    # @return [String] courier and name
    def full_name
        [courier_name, name].join(' ')
    end
end
