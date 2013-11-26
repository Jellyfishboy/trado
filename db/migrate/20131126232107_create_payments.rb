class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :pay_type_id
      t.integer :order_id

      t.timestamps
    end
  end
end
