class ChangeDiscountAmountColumnToDiscountValue < ActiveRecord::Migration
  def change
    rename_column :invoices, :discount_amount, :discount_value
  end
end
