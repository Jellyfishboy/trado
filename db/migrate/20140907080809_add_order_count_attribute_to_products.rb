class AddOrderCountAttributeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :order_count, :integer, default: 0
  end
end
