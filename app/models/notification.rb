class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :email, :sent, :sent_at
  validates :email, :presence => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  # TODO: If statement for the custom SKU message as the notifications table will be used throughout the application. Very adhoc.
  validates :email, :uniqueness => { :scope => :notifiable_id, :message => 'has already been submitted for this product SKU.' }
  belongs_to :notifiable, polymorphic: true
end
