class ChangeDataTypeForShippingStatusAtttributeInOrder < ActiveRecord::Migration
  def up
    remove_column :orders, :shipping_status, :string
    add_column :orders, :shipping_status, :integer, default: 0
  end

  def down
    remove_column :orders, :shipping_status, :integer, default: 0
    add_column :orders, :shipping_status, :string
  end
end
