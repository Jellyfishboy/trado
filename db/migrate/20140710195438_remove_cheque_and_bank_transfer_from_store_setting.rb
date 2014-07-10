class RemoveChequeAndBankTransferFromStoreSetting < ActiveRecord::Migration
  def change
    remove_column :store_settings, :cheque
    remove_column :store_settings, :bank_transfer
  end
end
