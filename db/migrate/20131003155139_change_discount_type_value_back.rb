class ChangeDiscountTypeValueBack < ActiveRecord::Migration
  def change
    change_column :invoices, :discount_type, :string
  end
end
