class AddStatusReasonColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :status_reason, :string
  end
end
