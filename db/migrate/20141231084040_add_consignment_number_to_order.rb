class AddConsignmentNumberToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :consignment_number, :string
  end
end
