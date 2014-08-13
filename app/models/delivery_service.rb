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

    has_many :prices,                                       class_name: 'DeliveryServicePrice', dependent: :delete_all

    validates :name, :courier_name,                         presence: true
    validates :name,                                        uniqueness: { scope: :courier_name }
    validates :description,                                 length: { maximum: 180, message: :too_long }

    default_scope { order(courier_name: :desc) }

    include ActiveScope

    def full_name
        [courier_name, name].join(' ')
    end
end
