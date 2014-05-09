class AddTaxAttributeToStoreSettings < ActiveRecord::Migration
  def change
    add_column :store_settings, :tax_rate, :decimal,:precision => 8, :scale => 2,:default => BigDecimal.new("20.0")
  end
end
