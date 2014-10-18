# User Documentation
#
# The user table enforces administration authentication for the applications content management system. 
# This is currently managed by Devise and CanCan.

# == Schema Information
#
# Table name: users
#
#  id                           :integer            not null, primary key
#  first_name                   :string(255)        default('Joe')
#  last_name                    :string(255)        default('Bloggs')
#  email                        :string(255),       not null, default("")   
#  encrypted_password           :string(255)        not null, default("")  
#  reset_password_token         :string(255)        
#  reset_password_sent_at       :datetime            
#  remember_created_at          :datetime            
#  sign_in_count                :integer            default(0)
#  current_sign_in_at           :datetime   
#  last_sign_in_at              :datetime 
#  current_sign_in_ip           :string(255)  
#  last_sign_in_ip              :string(255)      
#  created_at                   :datetime           not null
#  updated_at                   :datetime           not null
#
class User < ActiveRecord::Base

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :attachment_attributes
    
    has_one :attachment,                                    as: :attachable, dependent: :destroy                            
    has_many :permissions,                                  dependent: :delete_all
    has_many :roles,                                        through: :permissions
    has_many :notifications,                                as: :notifiable, dependent: :delete_all

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

