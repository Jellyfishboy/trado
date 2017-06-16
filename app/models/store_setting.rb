# StoreSetting Documentation
#
# The store_setting table allows an administrator to modify the store wide settings.
# There is only one store_setting record, which is automatically assigned to the single administrator when installing Trado.
# == Schema Information
#
# Table name: store_settings
#
#  id                          :integer          not null, primary key
#  name                        :string           default("Trado")
#  email                       :string           default("admin@example.com")
#  currency                    :string           default("GBP|£")
#  tax_name                    :string           default("VAT")
#  user_id                     :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  ga_code                     :string           default("UA-XXXXX-X")
#  ga_active                   :boolean          default(FALSE)
#  tax_rate                    :decimal(8, 2)    default(20.0)
#  tax_breakdown               :boolean          default(FALSE)
#  theme_name                  :string           default("redlight")
#  locale                      :string           default("en")
#

class StoreSetting < ActiveRecord::Base
    
    attr_accessible :currency, :email, :name, :tax_name, :tax_rate, :tax_breakdown, :user_id, 
    :ga_active, :ga_code, :theme_name, :attachment_attributes, :locale

    has_one :attachment,                                                  as: :attachable, dependent: :destroy

    validates :name, :email, :tax_name, :currency, 
    :tax_rate, :theme_name, :locale,                                      presence: true

    accepts_nested_attributes_for :attachment

    after_commit :reset_settings
  
    def theme
        Theme.new(self.theme_name)
    end

    def currency_code
        currency.split('|').first
    end

    def currency_symbol
        currency.split('|').last
    end

    private

    def reset_settings
        Rails.cache.delete("store_setting")
        Rails.cache.write("store_setting", StoreSetting.first)
    end
end
