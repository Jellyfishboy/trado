# Role Documentation
#
# The role table contains a list of roles for various level of user authentication throughout the application.
# A user can have more than one role at any given time. 
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string           default("user")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
    attr_accessible :name

    has_many :permissions,                      dependent: :destroy   
    has_many :users,                            through: :permissions

end
