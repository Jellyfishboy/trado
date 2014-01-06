class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :transaction_id
      t.string :transaction_type
      t.string :payment_type
      t.decimal :fee, :precision => 8, :scale => 2
      t.string :payment_status
      t.integer :order_id
      t.decimal :gross_amount, :precision => 8, :scale => 2
      t.decimal :tax_amount, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
