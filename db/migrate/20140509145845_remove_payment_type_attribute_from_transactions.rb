class RemovePaymentTypeAttributeFromTransactions < ActiveRecord::Migration
  def up
    rename_column :transactions, :transaction_id, :paypal_id
  end

  def down
    rename_column :transactions, :paypal_id, :transaction_id
  end
end
