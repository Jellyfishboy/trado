class ChangeDataTypeOfErrorCodeInTransaction < ActiveRecord::Migration
  def up
    remove_column :transactions, :error_code, :string
    add_column :transactions, :error_code, :integer
  end

  def down
    remove_column :transactions, :error_code, :integer
    add_column :transactions, :error_code, :string
  end
end
