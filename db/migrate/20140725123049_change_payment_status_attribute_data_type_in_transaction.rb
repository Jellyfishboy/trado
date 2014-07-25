class ChangePaymentStatusAttributeDataTypeInTransaction < ActiveRecord::Migration
  def up
    remove_column :transactions, :payment_status, :string
    add_column :transactions, :payment_status, :integer, default: 0
  end

  def down
    remove_column :transactions, :payment_status, :integer, default: 0
    add_column :transactions, :payment_status, :string
  end
end
