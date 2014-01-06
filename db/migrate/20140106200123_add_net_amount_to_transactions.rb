class AddNetAmountToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :net_amount, :decimal, :precision => 8, :scale => 2
  end
end
