# StoreSetting Documentation
#
# The store_setting table allows an administrator to modify the store wide settings.
# There is only one store_setting record, which is automatically assigned to the single administrator when installing Trado.

# == Schema Information
#
# Table name: store_settings
#
#  id               :integer                not null, primary key
#  name             :string(255)            default('Trado')
#  email            :string(255)            default('admin@example.com')
#  tax_name         :string(255)            default('VAT')    
#  currency         :string(255)            default('£')
#  ga_code          :string(255)
#  ga_active        :boolean                default(false)
#  created_at       :datetime               not null
#  updated_at       :datetime               not null
#
class StoreSetting < ActiveRecord::Base

  attr_accessible :currency, :email, :name, :tax_name, :user_id, :ga_active, :ga_code

  belongs_to :user

  validates :name, :email, :tax_name, :currency,                        :presence => true
  
end
