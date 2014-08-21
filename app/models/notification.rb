# Notification Documentation
#
# The notification table provides support for handling notifications throughout the application. 
# It has a polymorphic relation so can be utilised by various models.

# == Schema Information
#
# Table name: notifications
#
#  id                   :integer          not null, primary key
#  notifiable_id        :integer      
#  notifiable_type      :string(255) 
#  email                :string(255)   
#  sent                 :boolean          default(false)
#  sent_at              :datetime           
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Notification < ActiveRecord::Base

  attr_accessible :notifiable_id, :notifiable_type, :email, :sent, :sent_at

  belongs_to :notifiable, polymorphic: true

  validates :email,         presence: { message: 'is required' }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: { scope: :notifiable_id, message: 'notification has already been created.' }

end
