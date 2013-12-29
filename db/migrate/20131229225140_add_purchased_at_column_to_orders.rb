class AddPurchasedAtColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :purchased_at, :datetime
  end
end
