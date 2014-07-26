class AddErrorCodeAttributeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :error_code, :string
  end
end
