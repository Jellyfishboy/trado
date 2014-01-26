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

  # TODO: If statement for the custom SKU message as the notifications table will be used throughout the application. Very adhoc.
  validates :email,         :presence => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :uniqueness => { :scope => :notifiable_id, :message => 'has already been submitted for this product SKU.' }
  

  belongs_to :notifiable, polymorphic: true

end
