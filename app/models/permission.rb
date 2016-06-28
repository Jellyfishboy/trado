# Permission Documentation
#
# The permission table is a HABTM relationship handler between the users and roles tables.
# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Permission < ActiveRecord::Base
  attr_accessible :role_id, :user_id

  belongs_to :user
  belongs_to :role

end
