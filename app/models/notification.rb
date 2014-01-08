class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :email
  belongs_to :notifiable, polymorphic: true
end
