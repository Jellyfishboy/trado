class AddOrderIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :order_id, :integer
  end
end
