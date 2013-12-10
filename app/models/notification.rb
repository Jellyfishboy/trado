class Notification < ActiveRecord::Base
  attr_accessible :dimension_id, :email
  belongs_to :notifiable, polymorphic: true
end
