class ChangeStoreSettingDefaultCurrency < ActiveRecord::Migration
  def change
    change_column :store_settings, :currency, :string, default: 'GBP|£'
  end
end
