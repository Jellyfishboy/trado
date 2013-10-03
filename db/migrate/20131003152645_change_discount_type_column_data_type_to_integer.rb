class ChangeDiscountTypeColumnDataTypeToInteger < ActiveRecord::Migration
  def change
    change_column :invoices, :discount_type, :integer
  end
end
