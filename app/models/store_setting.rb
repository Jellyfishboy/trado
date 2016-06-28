# StoreSetting Documentation
#
# The store_setting table allows an administrator to modify the store wide settings.
# There is only one store_setting record, which is automatically assigned to the single administrator when installing Trado.
# == Schema Information
#
# Table name: store_settings
#
#  id            :integer          not null, primary key
#  name          :string           default("Trado")
#  email         :string           default("admin@example.com")
#  currency      :string           default("£")
#  tax_name      :string           default("VAT")
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ga_code       :string           default("UA-XXXXX-X")
#  ga_active     :boolean          default(FALSE)
#  tax_rate      :decimal(8, 2)    default(20.0)
#  tax_breakdown :boolean          default(FALSE)
#  theme_name    :string           default("redlight")
#

class StoreSetting < ActiveRecord::Base
    
    attr_accessible :currency, :email, :name, :tax_name, :tax_rate, :tax_breakdown, :user_id, 
    :ga_active, :ga_code, :theme_name, :attachment_attributes

    has_one :attachment,                                                  as: :attachable, dependent: :destroy

    validates :name, :email, :tax_name, :currency, 
    :tax_rate, :theme_name,                                               presence: true

    accepts_nested_attributes_for :attachment

    after_save :reset_settings
  
    def theme
        Theme.new(self.theme_name)
    end

    private

    def reset_settings
        Store.reset_settings
    end
end
