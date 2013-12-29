class AddExpressTokenToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :express_token, :string
    add_column :orders, :express_payer_id, :string
    remove_column :orders, :pay_type_id
  end
end
