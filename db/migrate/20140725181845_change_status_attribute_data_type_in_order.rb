class ChangeStatusAttributeDataTypeInOrder < ActiveRecord::Migration
  def up
    remove_column :orders, :status, :string
    add_column :orders, :status, :integer, default: 0
  end

  def down
    remove_column :orders, :status, :integer, default: 0
    add_column :orders, :status, :string
  end
end
