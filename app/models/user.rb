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
#  role                         :string(255)        default("user")
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

    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :attachment_attributes

    validates :first_name, :last_name,                      :presence => true
    
    has_one :attachment,                                    as: :attachable, :dependent => :destroy                            
    has_and_belongs_to_many :roles
    has_many :notifications,                                as: :notifiable, :dependent => :delete_all

    accepts_nested_attributes_for :attachment

    def role?(role)
        return !!self.roles.find_by_name(role.to_s.camelize)
    end

    # Combines the first and last name of a profile
    #
    # @return [string]
    def full_name 
        [first_name, last_name].join(' ')
    end

end

