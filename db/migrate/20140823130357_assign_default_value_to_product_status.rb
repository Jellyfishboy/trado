class AssignDefaultValueToProductStatus < ActiveRecord::Migration
  def change
    change_column :products, :status , :integer, default: 0
  end
end
