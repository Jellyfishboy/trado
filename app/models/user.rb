# User Documentation
#
# The user table enforces administration authentication for the applications content management system. 
# This is currently managed by Devise and CanCan.
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string           default("Joe")
#  last_name              :string           default("Bloggs")
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :attachment_attributes
    
    has_one :attachment,                                    as: :attachable, dependent: :destroy                            
    has_many :permissions,                                  dependent: :destroy
    has_many :roles,                                        through: :permissions
    has_many :notifications,                                as: :notifiable, dependent: :destroy

    validates :first_name, :last_name,                      presence: true

    accepts_nested_attributes_for :attachment

    # Checks if the user has a matching role to the symbol parameter passed
    #
    # @param role [Symbol]
    # @return [Boolean]
    def role? role
        return !!self.roles.find_by_name(role.to_s)
    end

    # Combines the first and last name of a profile
    #
    # @return [String] first and last name concatenated
    def full_name 
        [first_name, last_name].join(' ')
    end
end
