class SetDiscountValueDefaultValue < ActiveRecord::Migration
  def change
    change_column :invoices, :discount_value, :decimal, :default => 0
  end
end
