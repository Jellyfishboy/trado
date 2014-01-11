class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :email, :sent, :sent_at
  validates :email, :presence => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, :uniqueness => { :scope => :notifiable_id, :message => 'has already been submitted for this product SKU.' }
  belongs_to :notifiable, polymorphic: true
end
